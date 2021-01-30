part of 'auth.dart';

GoogleSignIn _gSignIn;
Future<GoogleSignIn> _getGSignIn() async {
  if (_gSignIn != null) {
    return _gSignIn;
  }
  final secrets = await loadSecrets();
  return _gSignIn = kIsWeb
      ? GoogleSignIn(clientId: secrets.GOOGLE_CLIENT_ID)
      : GoogleSignIn();
}

Future<UserLogin> signInWithGoogle({
  @required bool interactive,
}) async {
  authController.requestLogin();
  final cred = await getGoogleCredential(interactive: interactive);
  final res = await auth.signInWithCredential(cred);
  return signInWithFbUser(SignInMethod.google, res?.user);
}

Future<GoogleAuthCredential> getGoogleCredential({
  @required bool interactive,
}) async {
  final inst = await _getGSignIn();
  final acct = await (interactive ? inst.signIn() : inst.signInSilently());
  if (acct == null) {
    throw SignInError('user_canceled');
  }
  final authRes = await acct.authentication;
  final cred = GoogleAuthProvider.credential(
    accessToken: authRes.accessToken,
    idToken: authRes.idToken,
  );
  return cred;
}
