import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../user/data/user_model/user_model.dart';
import '../model/contact/chat_contact.dart';



class ChatContactRemoteDataSource  {
  final FirebaseFirestore fire;
  final FirebaseAuth auth;
  final Ref ref;

  ChatContactRemoteDataSource ({
    required this.fire,
    required this.auth,
    required this.ref,
  });

  Stream<List<ChatContactModel>> getDateChatContacts({required String userId}) {
    return fire
        .collection('users')
        .doc(userId)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModel> contactData = [];
      for (var doc in event.docs) {
        var chat = ChatContactModel.fromMap(doc.data());

        var userDataDoc = await fire.collection('users').doc(chat.contactId).get();
        if (!userDataDoc.exists) continue;

        var user = UserModel.fromMap(userDataDoc.data()!);

        var unreadMessagesQuery = await fire
            .collection('users')
            .doc(userId)
            .collection('chats')
            .doc(chat.contactId)
            .collection('messages')
            .where('isSeen', isEqualTo: false).where('senderId', isNotEqualTo: userId)
            .get();

        int unreadMessageCount = unreadMessagesQuery.docs.length;

        if (unreadMessageCount == 0) {
          await fire
              .collection('users')
              .doc(userId)
              .collection('chats')
              .doc(chat.contactId)
              .update({'unreadMessageCount': 0});
        }

        contactData.add(ChatContactModel(
          name: user.name,
          prof: user.profile,
          contactId: chat.contactId,
          time: chat.time,
          lastMessage: chat.lastMessage,

          unreadMessageCount: unreadMessageCount,
          receiverId: chat.receiverId,
          isSeen: unreadMessageCount == 0,  isArchived: false, isOnline: chat.isOnline,
        ));
      }
      return contactData;
    });
  }




  Stream<List<ChatContactModel>> searchContact({required String searchName}) {
    return fire.collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .map((snapshot) {
      final lowerQuery = searchName.toLowerCase();
      return snapshot.docs
          .map((doc) => ChatContactModel.fromMap(doc.data()))
          .where((chat) => chat.name.toLowerCase().contains(lowerQuery))
          .toList();
    });
  }

  Future<void> archiveChat({required String id}) async {
    await fire
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(id)
        .update({'isArchived': true});
  }

  Stream<List<ChatContactModel>> getUnarchivedChats() {
    return fire
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .where('isArchived', isEqualTo: false)
        .snapshots()
        .map((snap) => snap.docs.map((e) => ChatContactModel.fromMap(e.data())).toList());
  }
  Stream<List<ChatContactModel>> getArchivedChats() {
    return fire
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .where('isArchived', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs.map((e) => ChatContactModel.fromMap(e.data())).toList());
  }
  Future<void> unarchiveChat(String chatId) async {
    await fire
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(chatId)
        .update({'isArchived': false});
  }
  Future<void> deleteChat({
    required String receiverId,
  }) async {
    try {
      await fire
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverId)
          .delete();
    } catch (e) {
      print("Error deleting chat: $e");
      rethrow;
    }
  }



}
