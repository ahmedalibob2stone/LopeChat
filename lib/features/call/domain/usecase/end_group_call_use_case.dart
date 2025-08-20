
import '../repository/call_repository.dart';

class EndGroupCallUseCase {
  final CallRepository repository;

  EndGroupCallUseCase(this.repository);

  Future<void> call(String callId,String groupId) {
    return repository.endGroupCall(callId,groupId);
  }
}
