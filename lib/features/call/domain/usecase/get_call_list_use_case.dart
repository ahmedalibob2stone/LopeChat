
import '../entites/callentites.dart';
import '../repository/call_repository.dart';

class GetCallListUseCase {
  final CallRepository repository;

  GetCallListUseCase(this.repository);

  Stream<List<CallEntites>> call() {
    return repository.getCallList();
  }
}
