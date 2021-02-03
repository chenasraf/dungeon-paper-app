import 'dart:math';
import 'package:dungeon_paper/routes.dart';
import 'package:dungeon_paper/src/atoms/version_number.dart';
import 'package:dungeon_paper/src/dialogs/single_field_edit_dialog.dart';
import 'package:dungeon_paper/src/flutter_utils/loading_container.dart';
import 'package:dungeon_paper/src/pages/auth/login_view.dart';
import 'package:dungeon_paper/src/pages/whats_new_view/whats_new_view.dart';
import 'package:dungeon_paper/src/utils/auth/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeView extends StatelessWidget {
  final bool loading;

  const WelcomeView({
    Key key,
    @required this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
      loading: loading,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: DefaultTextStyle(
              style: Get.theme.textTheme.bodyText2
                  .copyWith(color: Get.theme.accentColor),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox.fromSize(
                    size: Size.square(min(Get.mediaQuery.size.width - 32, 200)),
                    child: Image.asset('assets/logo.png'),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Welcome to Dungeon Paper!',
                    textScaleFactor: 1.75,
                  ),
                  VersionNumber.text(prefix: 'Version'),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Sign up to Dungeon Paper to sync your characters, '
                      'custom content and settings',
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.1,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(height: 24),
                  LoginView(),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text('Information'),
                          RaisedButton(
                            color: Get.theme.colorScheme.surface,
                            onPressed: _openWhatsNew,
                            child: Text('Changelog'),
                          ),
                          RaisedButton(
                            color: Get.theme.colorScheme.surface,
                            onPressed: _openPrivacyPolicy,
                            child: Text('Privacy Policy'),
                          ),
                        ],
                      ),
                      SizedBox(width: 12),
                      Column(
                        children: [
                          Text("Can't sign in?"),
                          RaisedButton(
                            color: Get.theme.colorScheme.surface,
                            onPressed: _openResetPasswordView,
                            child: Text('Reset Password'),
                          ),
                          RaisedButton(
                            color: Get.theme.colorScheme.surface,
                            onPressed: _openAboutView,
                            child: Text('Contact Us'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openAboutView() {
    Get.toNamed(Routes.about.path);
  }

  void _openResetPasswordView() {
    Get.dialog(
      SingleTextFieldEditDialog(
        title: Text('Reset Password'),
        confirmText: Text('Send Password Reset'),
        fieldName: 'Email address',
        value: '',
        onCancel: () => Get.back(),
        confirmDisabled: (email) => !EmailValidator.validate(email),
        onSave: (email) async {
          await sendPasswordResetLink(email);
          Get.back();
        },
      ),
    );
  }

  void _openWhatsNew() {
    Get.dialog(WhatsNew.dialog());
  }

  void _openPrivacyPolicy() {
    launch('https://casraf.blog/dungeon-paper-privacy-policy');
  }
}
