
import '../entites/callentites.dart';
import '../repository/call_repository.dart';

class GetStreamCallsUseCase {
  final CallRepository repository;

  GetStreamCallsUseCase(this.repository);

  Stream<List<CallEntites>> call() {
    return repository.getStreamCalls();
  }
}
