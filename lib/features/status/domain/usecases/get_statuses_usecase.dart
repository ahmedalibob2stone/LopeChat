  import '../entities/status_entity.dart';
  import '../repositories/status_repository.dart';

  class GetStatusesUseCase {
    final IStatusRepository repository;

    GetStatusesUseCase(this.repository);

    Stream<List<StatusEntity>>call() {
      return repository.getStatusStream();
    }
  }
