import 'dart:async';

import 'package:dungeon_paper/src/flutter_utils/platform_svg.dart';
import 'package:dungeon_paper/src/flutter_utils/widget_utils.dart';
import 'package:dungeon_paper/src/pages/auth/email_auth_view.dart';
import 'package:dungeon_paper/src/controllers/auth_controller.dart';
import 'package:dungeon_paper/src/utils/auth/auth.dart';
import 'package:dungeon_paper/src/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_button.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoginButton(
          label: 'Sign In with Google',
          color: Colors.white,
          icon: Image(
            image: AssetImage('assets/social/google.png'),
            width: 30,
            height: 30,
          ),
          onPressed: () => _signIn(
            context,
            () => signInWithGoogle(interactive: true),
          ),
        ),
        SizedBox(height: 5),
        FutureBuilder(
          future: checkAppleSignIn(),
          builder: (context, AsyncSnapshot<bool> available) =>
              available.data == true
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: LoginButton(
                        label: 'Sign In with Apple',
                        color: Colors.black,
                        textColor: Colors.white,
                        icon: PlatformSvg.asset(
                          'social/apple.svg',
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () => _signIn(
                          context,
                          () => signInWithApple(interactive: true),
                        ),
                      ),
                    )
                  : Container(),
        ),
        // LoginButton(
        //   label: 'Sign In with Facebook',
        //   color: Color(0xFF1878F3),
        //   textColor: Colors.white,
        //   icon: PlatformSvg.asset(
        //     'social/facebook.svg',
        //     size: 20,
        //     color: Colors.white,
        //   ),
        //   onPressed: () => _signIn(
        //     context,
        //     () => signInWithGoogle(interactive: true),
        //   ),
        // ),
        // SizedBox(height: 5),
        LoginButton(
          label: 'Sign In with Email',
          textColor: Get.theme.colorScheme.onSecondary,
          icon: Icon(
            Icons.email,
            color: Get.theme.colorScheme.onSecondary,
          ),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => EmailAuthView(
              onConfirm: _emailSignIn(context),
            ),
          ),
        ),
      ],
    );
  }

  void _signIn(BuildContext context, void Function() doLogin) async {
    try {
      await doLogin();
    } on SignInError catch (err, stack) {
      logger.e('Normal sign in error:', err, stack);
      authController.noLogin();
      Get.snackbar(
        'Error',
        'Login failed.',
        duration: SnackBarDuration.long,
      );
    } catch (err, stack) {
      logger.e('Irregular sign in error:', err, stack);
      authController.noLogin();
      Get.snackbar(
        'Error',
        'Something went wrong... Please try again later.',
        duration: Duration(seconds: 10),
      );
    }
  }

  Future<EmailAuthResponse> Function(EmailAuthResult) _emailSignIn(
    BuildContext context,
  ) {
    return (result) async {
      final completer = Completer<EmailAuthResponse>();
      await _signIn(
        context,
        () async {
          try {
            if (result.isSignUp) {
              await createUserWithEmailAndPassword(
                email: result.credential.email,
                password: result.credential.password,
              );
            } else {
              await signInWithEmailAndPassword(
                email: result.credential.email,
                password: result.credential.password,
              );
            }
            Get.back();
            completer.complete(EmailAuthResponse());
          } catch (e, stack) {
            completer.complete(EmailAuthResponse(e, stack));
          }
        },
      );
      return completer.future;
    };
  }
}
