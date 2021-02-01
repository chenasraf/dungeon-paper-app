import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:dungeon_paper/db/db.dart';
import 'package:dungeon_paper/db/listeners.dart';
import 'package:dungeon_paper/db/models/user.dart';
import 'package:dungeon_paper/src/controllers/auth_controller.dart';
import 'package:dungeon_paper/src/controllers/characters_controller.dart';
import 'package:dungeon_paper/src/controllers/custom_classes_controller.dart';
import 'package:dungeon_paper/src/controllers/user_controller.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/api.dart';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:dungeon_paper/src/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pedantic/pedantic.dart';
import 'package:platform/platform.dart';
import 'auth_common.dart';
export 'auth_common.dart';
part 'auth_email.dart';
part 'auth_google.dart';
part 'auth_apple.dart';
part 'auth_helpers.dart';

Future<UserLogin> signInWithCredentials(AuthCredential creds) async {
  assert(creds != null);
  authController.requestLogin();

  final res = await auth.signInWithCredential(creds);
  return signInWithFbUser(
    SignInMethod.fromProviderId(res.credential.providerId),
    res?.user,
  );
}

Future<bool> withReauth<T>(
  Future<T> Function(fb.User) callback, {
  @required String errorMessage,
  bool dispatchUser = true,
}) async {
  final user = auth.currentUser;
  try {
    await callback(user);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      await Future.delayed(Duration(seconds: 2));
      await reauthenticateUser(user);
      await callback(user);
      return true;
    }
    rethrow;
  } catch (e, stack) {
    logger.w(errorMessage, e, stack);
    return false;
  }
}

Future<bool> linkWithCredentials(AuthCredential creds) async {
  return withReauth(
    (user) => user.linkWithCredential(creds),
    errorMessage: 'Could not link with credential: $creds',
  );
}

Future<bool> unlinkFromProvider(String providerId) async {
  final user = auth.currentUser;
  final firstOtherProvider = user.providerData.firstWhere(
      (data) => data.providerId != providerId && data.email?.isNotEmpty == true,
      orElse: () => null);
  final newEmail = firstOtherProvider?.email;
  return withReauth(
    (user) async {
      await user.unlink(providerId);
      await user.reload();
      final dbUser = userController.current;
      await dbUser.changeEmail(newEmail);
    },
    errorMessage: 'Could not unlink with provider: $providerId',
  );
}

Future<bool> updateFirebaseEmail(String email) async {
  return withReauth(
    (user) => user.updateEmail(email),
    errorMessage: 'Could not update email to: $email',
  );
}

Future<bool> reauthenticateUser(fb.User user) async {
  try {
    AuthCredential origCreds;
    final primary = getPrimaryAuthProvider(user);
    final signInMethod = primary.providerId;

    switch (signInMethod) {
      case 'google.com':
        origCreds = await getGoogleCredential(interactive: true);
        break;
      case 'apple.com':
        origCreds = await getAppleCredential(interactive: true);
        break;
      default:
        throw Exception('Unimplemented provider method');
    }

    await user.reauthenticateWithCredential(origCreds);
    return true;
  } catch (e) {
    return false;
  }
}

Future<void> sendPasswordResetLink(String email) async {
  await auth.sendPasswordResetEmail(email: email);
}

Future<UserLogin> signInAutomatically() async {
  authController.requestLogin();
  try {
    final user =
        await signInWithFbUser(SignInMethod.firebase, auth.currentUser);
    if (user == null) {
      throw SignInError('no_silent_login');
    }
    return user;
  } on SignInError {
    authController.noLogin();
    logger.d('Silent login failed');
    return null;
  } catch (e) {
    authController.noLogin();
    logger.d('Silent login unexpected error:');
    rethrow;
  }
}

Future<UserLogin> signInWithFbUser(
    SignInMethod signInMethod, fb.User fbUser) async {
  final dbUser = await getDatabaseUser(
    fbUser,
    signInMethod: signInMethod,
  );

  dispatchFinalDataToStore(
    firebaseUser: fbUser,
    user: dbUser,
  );

  return UserLogin(
    firebaseUser: fbUser,
    user: dbUser,
  );
}

Future<void> signOutAll() async {
  authController.logout();
  await _getGSignIn();
  unawaited(_gSignIn.disconnect());
  unawaited(auth.signOut());
}

void dispatchFinalDataToStore({
  @required fb.User firebaseUser,
  @required User user,
}) async {
  if ([firebaseUser, user].any((el) => el == null)) {
    authController.noLogin();
    return;
  }

  authController.login(
    user: user,
    firebaseUser: firebaseUser,
  );

  _setUserProperties(firebaseUser, user);
  registerAllListeners(firebaseUser);
}

void _setUserProperties(fb.User firebaseUser, User user) {
  unawaited(analytics.logLogin(
    loginMethod: 'firebase',
  ));
  unawaited(analytics.setUserId(firebaseUser.uid));
  unawaited(analytics.setUserProperty(
    name: 'document_id',
    value: user.documentID,
  ));
  unawaited(analytics.setUserProperty(
    name: 'is_tester',
    value: user.isTester.toString(),
  ));
  unawaited(analytics.setUserProperty(
    name: 'connected_accounts',
    value: firebaseUser.providerData.map((d) => d.providerId).join(','),
  ));
  unawaited(analytics.setUserProperty(
    name: 'characters_count',
    value: characterController.all.length.toString(),
  ));
  unawaited(analytics.setUserProperty(
    name: 'classes_count',
    value: customClassesController.classes.length.toString(),
  ));
  if (!kIsWeb) {
    unawaited(analytics.setUserProperty(
      name: 'latest_platform_name',
      value: LocalPlatform().operatingSystem,
    ));
    unawaited(analytics.setUserProperty(
      name: 'latest_platform_version',
      value: LocalPlatform().operatingSystemVersion,
    ));
  }
  unawaited(analytics.setUserProperty(
    name: 'latest_device_type',
    value: Get.mediaQuery.size.shortestSide < 600 ? 'mobile' : 'tablet',
  ));
}

void registerAllListeners(fb.User fbUser) {
  registerFirebaseUserListener();
}
