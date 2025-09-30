
import '../repositories/status_repository.dart';

class MarkStatusAsSeenUseCase {
  final IStatusRepository repository;

  MarkStatusAsSeenUseCase({required this.repository});

  Future<void> call({
    required String statusId,
    required String imageUrl,
    required String currentUserUid,
  }) async {
    await repository.markStatusAsSeen(
      statusId: statusId,
      imageUrl: imageUrl,
      currentUserUid: currentUserUid,
    );
  }
}
