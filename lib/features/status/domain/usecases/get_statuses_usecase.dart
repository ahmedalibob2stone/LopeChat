import '../entities/status_entity.dart';
import '../repositories/status_repository.dart';

class GetStatusesUseCase {
  final IStatusRepository repository;

  GetStatusesUseCase(this.repository);

  Future<List<StatusEntity>> call() {
    return repository.getStatuses();
  }
}
