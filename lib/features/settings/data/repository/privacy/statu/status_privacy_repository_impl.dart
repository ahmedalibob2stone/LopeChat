import '../../../../domain/entities/privacy/statu/statu_privacy_entity.dart';
import '../../../../domain/repository/privacy/statu/status_privacy_repository.dart';
import '../../../datasource/privacy/statu/status_privacy_local_datasorce.dart';
import '../../../datasource/privacy/statu/status_privacy_remote_datasorce.dart';
import '../../../model/privacy/statu/status_privacy_model.dart';

class StatusPrivacyRepositoryImpl implements StatusPrivacyRepository {
  final StatusPrivacyRemoteDataSource remoteDataSource;
  final StatusPrivacyLocalDataSource localDataSource;

  StatusPrivacyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<StatusPrivacyEntity> getStatusPrivacy(String userId) async {
    final localModel = await localDataSource.getStatusPrivacy(userId);
    if (localModel != null) {
      _updateFromRemote(userId);
      return localModel;
    }

    final remoteModel = await remoteDataSource.getStatusPrivacy(userId: userId);
    if (remoteModel != null) {
      await localDataSource.saveStatusPrivacy(userId, remoteModel);
      return remoteModel;
    }

    return StatusPrivacyEntity(
      option: StatusPrivacyOption.allContacts,
      excludedContactsIds: [],
      includedContactsIds: [],
    );
  }

  Future<void> _updateFromRemote(String userId) async {
    try {
      final remoteModel = await remoteDataSource.getStatusPrivacy(userId: userId);
      if (remoteModel != null) {
        await localDataSource.saveStatusPrivacy(userId, remoteModel);
      }
    } catch (_) {
    }
  }

  @override
  Future<void> saveStatusPrivacy(StatusPrivacyEntity privacy, String userId) async {
    final model = StatusPrivacyModel(
      option: privacy.option,
      excludedContactsIds: privacy.excludedContactsIds,
      includedContactsIds: privacy.includedContactsIds,
    );
    await localDataSource.saveStatusPrivacy(userId, model);

    await remoteDataSource.saveStatusPrivacy(userId: userId, statusPrivacy: model);
  }
}
