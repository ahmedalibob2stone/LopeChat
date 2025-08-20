import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/chat_model/chat_model.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRemoteDataSource({
    required this.firestore,
    required this.auth,
  });

  Future<void> toggleDisappearingMessages({
    required String chatId,
    required bool isEnabled,
    required int durationSeconds,
  }) async {
    await firestore.collection('chats').doc(chatId).update({
      'disappearingMessages': {
        'isEnabled': isEnabled,
        'durationSeconds': durationSeconds,
      }
    });
  }

  Stream<DisappearingMessagesConfig> getDisappearingMessagesConfig(String chatId) {
    return firestore.collection('chats').doc(chatId).snapshots().map((doc) {
      final data = doc.data()?['disappearingMessages'] as Map<String, dynamic>?;

      if (data != null) {
        return DisappearingMessagesConfig.fromMap(data);
      } else {
        return DisappearingMessagesConfig(isEnabled: false, durationSeconds: 0);
      }
    });
  }
}
