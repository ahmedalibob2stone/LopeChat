import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteAccountRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  DeleteAccountRemoteDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<void> deleteAccount(String uid) async {

    final currentUser = _auth.currentUser;
    if (currentUser == null || currentUser.uid != uid) {
      throw Exception('User not authenticated or mismatched uid');
    }

    await _firestore.collection('users').doc(uid).delete();


    await currentUser.delete();
  }
}
