import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/call/call_model.dart';

import 'package:lopechat/features/group/data/model/group/group.dart' as model;

class CallRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRemoteDataSource({required this.firestore, required this.auth});

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  Future<void> createCall(CallModel senderCall, CallModel receiverCall) async {
    await firestore.collection('call').doc(senderCall.callerId).set(senderCall.toMap());
    await firestore.collection('call').doc(receiverCall.receiverId).set(receiverCall.toMap());
  }

  Future<void> makeGroupCall(CallModel senderCall, CallModel receiverCall) async {
    await firestore.collection('call').doc(senderCall.callerId).set(senderCall.toMap());

    final groupSnap = await firestore.collection('groups').doc(senderCall.receiverId).get();

    if (groupSnap.exists && groupSnap.data() != null) {
      final group = model.GroupModel.fromMap(groupSnap.data()!);

      for (var id in group.membersUid) {
        await firestore.collection('call').doc(id).set(receiverCall.toMap());
      }
    } else {
      throw Exception("Group data not found for id: ${senderCall.receiverId}");
    }
  }

  Future<void> endCall(String callerId, String receiverId) async {
    await firestore.collection('call').doc(callerId).delete();
    await firestore.collection('call').doc(receiverId).delete();
  }

  Future<void> endGroupCall(String callerId, String groupId) async {
    await firestore.collection('call').doc(callerId).delete();

    final groupSnap = await firestore.collection('groups').doc(groupId).get();

    if (groupSnap.exists && groupSnap.data() != null) {
      final group = model.GroupModel.fromMap(groupSnap.data()!);

      for (var id in group.membersUid) {
        await firestore.collection('call').doc(id).delete();
      }
    } else {
      throw Exception("Group data not found for id: $groupId");
    }
  }

  Stream<List<CallModel>> getCallList() {
    return firestore.collection('call').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => CallModel.fromMap(doc.data())).toList());
  }
  Stream<List<CallModel>> getStreamCalls() {
    return firestore.collection('call').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CallModel.fromMap(doc.data())).toList();
    });
  }

  Future<void> deleteCall(String userId) async {
    await firestore.collection('call').doc(userId).delete();
  }
}
