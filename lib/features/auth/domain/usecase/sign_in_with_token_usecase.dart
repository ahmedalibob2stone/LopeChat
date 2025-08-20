import 'package:firebase_auth/firebase_auth.dart';

class SignInWithTokenUseCase {
  final FirebaseAuth _firebaseAuth;

  SignInWithTokenUseCase(this._firebaseAuth);

  Future<void> execute(String token) async {
    await _firebaseAuth.signInWithCustomToken(token);
  }

  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }
}
