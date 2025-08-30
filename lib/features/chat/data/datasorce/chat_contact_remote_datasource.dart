import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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


  Stream<List<ChatContactModel>> searchContact({required String searchName}) {
    return fire.collection('users').
    doc(auth.currentUser!.uid).collection('chats')
        .where('name', isGreaterThanOrEqualTo: searchName)
        .where('name', isLessThanOrEqualTo: searchName + '\uf8ff')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => ChatContactModel.fromMap(doc.data())).toList());
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
