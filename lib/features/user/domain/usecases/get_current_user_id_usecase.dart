import 'package:firebase_auth/firebase_auth.dart';

class GetCurrentUserIdUseCase {
  final FirebaseAuth auth;

  GetCurrentUserIdUseCase(this.auth);

  String call() {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");
    return uid;
  }
}
