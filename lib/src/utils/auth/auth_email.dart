part of 'auth.dart';

Future<UserLogin> signInWithEmailAndPassword({
  @required String email,
  @required String password,
}) async {
  authController.requestLogin();
  final res = await performEmailAuth(email, password);
  return signInWithFbUser(SignInMethod.password, res?.user);
}

Future<UserLogin> createUserWithEmailAndPassword({
  @required String email,
  @required String password,
}) async {
  assert(email != null && password != null);
  authController.requestLogin();
  final res = await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  return signInWithFbUser(SignInMethod.password, res?.user);
}

Future<fb.UserCredential> performEmailAuth(
    String email, String password) async {
  final res = await auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  return res;
}
