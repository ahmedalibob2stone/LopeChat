import '../../../../domain/entities/privacy/last seen and online/last_seen_and_online.dart';
import '../../../../domain/repository/privacy/last seen and online/privacy_repository.dart';
import '../../../datasource/privacy/last seen and online/last_seen_and_online_privacy_local_datasorce.dart';
import '../../../datasource/privacy/last seen and online/last_seen_and_online_privacy_remote_datasource.dart';
import '../../../model/privacy/last seen and online/last_seen_online_model.dart';

class LastSeenAndOnlineRepositoryImpl implements LastSeenAndOnlineRepository {
  final LastSeenAndOnlineRemoteDataSource remoteDataSource;
  final LastSeenAndOnlineLocalDataSource localDataSource;

  LastSeenAndOnlineRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> saveLastSeenAndOnlineSettings(LastSeenAndOnlineEntity entity, String uid) async {
    final model = LastSeenAndOnlineModel.fromEntity(entity);

    await remoteDataSource.setLastSeenAndOnlineSettings(model, uid);

    await localDataSource.cacheLastSeenAndOnlineSettings(model);
  }

  @override
  Future<LastSeenAndOnlineEntity?> getLastSeenAndOnlineSettings(String uid) async {
    try {
      final model = await remoteDataSource.getLastSeenAndOnlineSettings(uid);

      await localDataSource.cacheLastSeenAndOnlineSettings(model);

      return model.toEntity();
    } catch (e) {
      final cached = await localDataSource.getCachedLastSeenAndOnlineSettings();
      return cached?.toEntity();
    }
  }
}
