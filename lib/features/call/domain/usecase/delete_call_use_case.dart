
import '../repository/call_repository.dart';

class DeleteCallUseCase {
  final CallRepository repository;

  DeleteCallUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.deleteCall(userId);
  }
}
