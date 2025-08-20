
import '../entites/callentites.dart';
import '../repository/call_repository.dart';

class MakeGroupCallUseCase {
  final CallRepository repository;

  MakeGroupCallUseCase(this.repository);

  Future<void> call(CallEntites senderCall, CallEntites receiverCall) {
    return repository.makeGroupCall(senderCall,receiverCall);
  }
}
