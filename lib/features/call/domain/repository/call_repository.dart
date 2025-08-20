// call_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entites/callentites.dart';

abstract class CallRepository {

  Future<void> createCall(CallEntites senderCall, CallEntites receiverCall);
  Future<void> makeGroupCall(CallEntites senderCall, CallEntites receiverCall);
  Stream<DocumentSnapshot> get callStream;
  Future<void> endCall(String callerId, String receiverId);
  Future<void> endGroupCall(String callerId, String groupId);
  Stream<List<CallEntites>> getCallList();
  Stream<List<CallEntites>> getStreamCalls();

  Future<void> deleteCall(String userId);
}
