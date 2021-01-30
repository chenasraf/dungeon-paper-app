import 'dart:io';

import 'package:dungeon_paper/db/models/user.dart';
import 'package:dungeon_paper/src/atoms/user_avatar.dart';
import 'package:dungeon_paper/src/dialogs/confirmation_dialog.dart';
import 'package:dungeon_paper/src/dialogs/single_field_edit_dialog.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/pages/account_view/auth_provider_tile.dart';
import 'package:dungeon_paper/src/controllers/user_controller.dart';
import 'package:dungeon_paper/src/scaffolds/main_scaffold.dart';
import 'package:dungeon_paper/src/utils/analytics.dart';
import 'package:dungeon_paper/src/utils/auth/auth.dart';
import 'package:dungeon_paper/src/utils/share.dart';
import 'package:dungeon_paper/src/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pedantic/pedantic.dart';

class AccountView extends StatefulWidget {
  static final _providersData = [
    AuthProviderTileData(
      id: 'password',
      displayName: 'Email & Password',
    ),
    AuthProviderTileData(
      id: 'google.com',
      displayName: 'Google',
    ),
    AuthProviderTileData(
      id: 'apple.com',
      displayName: 'Apple',
    ),
  ];

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  bool passwordResetSent;
  bool loadingPasswordReset;
  File imageFile;

  @override
  void initState() {
    analytics.setCurrentScreen(screenName: ScreenNames.Account);
    passwordResetSent = false;
    loadingPasswordReset = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final user = userController.current;
        final fbUser = userController.firebaseUser;
        final hasPassword = isUserLinkedToAuth('password', fbUser);
        return MainScaffold(
          key: Key('${fbUser.email}-${fbUser.displayName}-${fbUser.photoURL}'),
          automaticallyImplyLeading: true,
          title: Text('Your Account'),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: InkWell(
                  onTap: _pickImage(user),
                  child: Stack(
                    children: [
                      UserAvatar(user: user),
                      Positioned.fill(
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            shape: CircleBorder(),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 30,
                              color: Colors.black.withOpacity(0.8),
                              child: Transform.translate(
                                offset: Offset(0, -4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'UPLOAD',
                                      style: TextStyle(color: Colors.white),
                                      textScaleFactor: 0.7,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Display name'),
                      subtitle: Text(user.displayName),
                      trailing: Icon(Icons.edit),
                      onTap: () => _openEditDisplayName(context, user),
                    ),
                    if (hasPassword) ...[
                      ListTile(
                        title: Text('Email address'),
                        subtitle: Text(user.email),
                        trailing: Icon(Icons.edit),
                        onTap: () => _openEditEmail(context, user),
                      ),
                      ListTile(
                        title: Text('Password'),
                        subtitle: passwordResetSent
                            ? Text(passwordResetSent
                                ? 'A password reset link has been sent to your email address.'
                                : 'You can log in using your email and password')
                            : null,
                        trailing: FlatButton(
                          textColor: Get.theme.colorScheme.secondary,
                          child: loadingPasswordReset
                              ? Loader.button(color: Get.theme.accentColor)
                              : Text(passwordResetSent
                                  ? 'Send Again'
                                  : 'Reset Password'),
                          onPressed: () => _sendPasswordReset(context, fbUser),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Ways to log in',
                  style: Get.theme.textTheme.subtitle2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    for (var provider in AccountView._providersData)
                      AuthProviderTile(
                        key: Key('provider-' + provider.id),
                        data: provider,
                        user: fbUser,
                      )
                  ],
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Need help on your adventure?\nStuck trying to save the universe?',
                      textAlign: TextAlign.center,
                    ),
                    RaisedButton(
                      child: Text('Invite a friend', textScaleFactor: 1.1),
                      color: Get.theme.colorScheme.secondary,
                      textColor: Get.theme.colorScheme.onSecondary,
                      onPressed: _shareAppLink,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareAppLink() {
    analytics.logEvent(name: Events.ShareApp);
    shareAppLink();
  }

  void _openEditEmail(BuildContext context, User user) {
    analytics.logEvent(name: Events.EditEmailAttempt);
    showDialog(
      context: context,
      builder: (context) => SingleTextFieldEditDialog(
        value: user.email,
        fieldName: 'Email address',
        title: Text('Edit Email'),
        onSave: (email) async {
          unawaited(analytics.logEvent(name: Events.EditEmailConfirm));
          await user.changeEmail(email);
          Get.back();
        },
        onCancel: () {
          unawaited(analytics.logEvent(name: Events.EditEmailCancel));
          Get.back();
        },
      ),
    );
  }

  void _openEditDisplayName(BuildContext context, User user) {
    analytics.logEvent(name: Events.EditDisplayNameAttempt);

    showDialog(
      context: context,
      builder: (context) => SingleTextFieldEditDialog(
        value: user.displayName,
        fieldName: 'Display Name',
        title: Text('Edit Display Name'),
        onSave: (displayName) async {
          unawaited(analytics.logEvent(name: Events.EditDisplayNameConfirm));
          await user.ref.update({'displayName': displayName});
          Get.back();
        },
        onCancel: () {
          unawaited(analytics.logEvent(name: Events.EditDisplayNameCancel));
          Get.back();
        },
      ),
    );
  }

  void _sendPasswordReset(BuildContext context, fb.User user) async {
    unawaited(analytics.logEvent(name: Events.PasswordResetAttempt));
    final res = await Get.dialog<bool>(ConfirmationDialog(
      okButtonText: Text('Reset Password'),
      title: Text('Reset Password'),
      text: Text(
          'Selecting "Reset Password" will send a link to your account\'s email address,'
          'which you can use to change your password to a new one.\n\n'
          'The email address that will be sent to is:\n\n'
          '\t\t\t${user.email}'),
    ));
    if (res == true) {
      unawaited(analytics.logEvent(name: Events.PasswordResetConfirm));
      setState(() => loadingPasswordReset = true);
      await sendPasswordResetLink(user.email);
      setState(() {
        loadingPasswordReset = false;
        passwordResetSent = true;
      });
    } else {
      unawaited(analytics.logEvent(name: Events.PasswordResetCancel));
    }
  }

  void Function() _pickImage(User user) {
    return () async {
      final picker = ImagePicker();

      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        imageFile = File(pickedFile.path);
      });

      _upload(user);
    };
  }

  void _upload(User user) async {
    if (imageFile == null) {
      return;
    }
    final downloadURL = await uploadImage(
      imageFile,
      directory: 'user_photos',
      analyticsSource: ScreenNames.Account,
    );
    setState(() {
      imageFile = null;
    });
    await user.ref.update({'photoURL': downloadURL});
  }
}
