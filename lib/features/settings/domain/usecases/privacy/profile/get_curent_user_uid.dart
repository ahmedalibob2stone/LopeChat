import 'package:firebase_auth/firebase_auth.dart';

class GetCurrentUserIdUseCase {
  final FirebaseAuth auth;

  GetCurrentUserIdUseCase(this.auth);

  String call() {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw Exception("User is not authenticated");
    }
    return uid;
  }
}
