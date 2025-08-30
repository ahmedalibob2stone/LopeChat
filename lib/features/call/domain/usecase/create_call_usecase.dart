
import '../entites/callentites.dart';
import '../repository/call_repository.dart';

class CreateCallUseCase {
  final CallRepository repository;

  CreateCallUseCase(this.repository);

  Future<void> call(CallEntites senderCall, CallEntites receiverCall) {
    return repository.createCall(senderCall, receiverCall);
  }

}
