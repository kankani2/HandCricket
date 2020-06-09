import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signInAnonymously() async {
  try {
    await FirebaseAuth.instance.signInAnonymously();
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<String> getFirebaseAuthToken() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  IdTokenResult idTokenResult = await user.getIdToken();
  return idTokenResult.token;
}
