import '../repositories/status_repository.dart';

class DeleteStatusUseCase {
  final IStatusRepository repository;

  DeleteStatusUseCase(this.repository);

  Future<bool> call({
   required String statusId,
    required int index,
    required List<String> photoUrls,
  }) {
    return repository.deleteStatusPhoto(statusId,index, photoUrls);
    //  Future<bool> deleteStatusPhoto(String statusId, int index, List<String> photoUrls)
  }
}
