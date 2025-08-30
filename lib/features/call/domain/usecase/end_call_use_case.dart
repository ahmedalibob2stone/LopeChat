

import 'package:lopechat/features/call/domain/repository/call_repository.dart';

class EndCallUseCase {
  final CallRepository repository;

  EndCallUseCase(this.repository);

  Future<void> call(String callId,String receiverId) {
    return repository.endCall(callId,receiverId);
  }
}
