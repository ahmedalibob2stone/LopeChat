import '../repositories/status_repository.dart';

class DeleteStatusUseCase {
  final IStatusRepository repository;

  DeleteStatusUseCase(this.repository);

  Future<bool> call({
    required int index,
    required List<String> photoUrls,
  }) {
    return repository.deleteStatus(index, photoUrls);
  }
}
