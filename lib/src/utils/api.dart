import 'package:dungeon_paper/db/db.dart';
import 'package:dungeon_paper/db/models/character.dart';
import 'package:dungeon_paper/db/models/user.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import 'package:pedantic/pedantic.dart';
import 'package:uuid/uuid.dart';

Future<User> getDatabaseUser(
  fb.User fbUser, {
  @required SignInMethod signInMethod,
}) async {
  if (fbUser == null) {
    return null;
  }
  final email = fbUser.email ??
      fbUser.providerData
          .firstWhere((element) => element.email?.isNotEmpty == true)
          ?.email;
  final userDoc = await firestore.collection('user_data').doc(email).get();
  final data = userDoc.data();
  var user = User.fromJson(
    data,
    ref: userDoc.reference,
  );
  if (data.isEmpty) {
    unawaited(analytics.logSignUp(signUpMethod: signInMethod.name));
    user = user.copyWith(
      displayName: fbUser.displayName ?? fbUser.email,
      email: fbUser.email,
      photoURL: fbUser.photoURL,
    );
    await helpers.create(userDoc.reference, data);
    await user.createCharacter(Character(key: Uuid().v4()));
  } else {
    if (user.email?.isEmpty != true) {
      user = user.copyWith(
        email: email,
      );
      await helpers.update(userDoc.reference, data, keys: ['email']);
    }
  }
  return user;
}
