
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entites/callentites.dart';
import '../../domain/repository/call_repository.dart';
import '../datasorce/call_remote_datasource.dart';
import '../model/call/call_model.dart';

class CallRepositoryImpl implements CallRepository {
  final CallRemoteDataSource remoteDataSource;

  CallRepositoryImpl(this.remoteDataSource);

  @override
  Stream<DocumentSnapshot> get callStream => remoteDataSource.callStream;

  @override
  Future<void> createCall(CallEntites senderCall, CallEntites receiverCall) {
    final senderModel = CallModel.fromEntity(senderCall);
    final receiverModel = CallModel.fromEntity(receiverCall);
    return remoteDataSource.createCall(senderModel, receiverModel);
  }

  @override
  Future<void> makeGroupCall(CallEntites senderCall, CallEntites receiverCall) {
    final senderModel = CallModel.fromEntity(senderCall);
    final receiverModel = CallModel.fromEntity(receiverCall);
    return remoteDataSource.makeGroupCall(senderModel, receiverModel);
  }
  @override
  Stream<List<CallEntites>> getStreamCalls() {
    return remoteDataSource.getStreamCalls().map(
          (models) => models.map((model) => model.toEntity()).toList(),
    );
  }
  @override
  Future<void> endCall(String callerId, String receiverId) =>
      remoteDataSource.endCall(callerId, receiverId);

  @override
  Future<void> endGroupCall(String callerId, String groupId) =>
      remoteDataSource.endGroupCall(callerId, groupId);
  @override
  Stream<List<CallEntites>> getCallList() {
    return remoteDataSource.getCallList().map((callModels) =>
        callModels.map((model) => model.toEntity()).toList()
    );
  }


  @override
  Future<void> deleteCall(String userId) => remoteDataSource.deleteCall(userId);
}
