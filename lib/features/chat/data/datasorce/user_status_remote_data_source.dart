import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserStatusRemoteDataSource {
  final FirebaseFirestore firestore;

  UserStatusRemoteDataSource(this.firestore);

  Future<void> updateUserStatus({
    required bool isOnline,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');

    final userDoc = firestore.collection('users').doc(uid);

    if (isOnline) {
      await userDoc.update({
        'isOnline': 'online',
      });
    } else {
      await userDoc.update({
        'isOnline': 'offline',
        'lastSeen': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<String> getUserLastSeen(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    if (!doc.exists) return '';
    return doc.data()?['lastSeen'] ?? '';
  }

  Future<String> getUserOnlineStatus(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    if (!doc.exists) return 'offline';
    return doc.data()?['isOnline'] ?? 'offline';
  }
}
