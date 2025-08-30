import '../../../../domain/entities/privacy/privacy_profile/privacy_profile_entity.dart';
import '../../../../domain/repository/privacy/profile/privacy_profile_repository.dart';
import '../../../datasource/privacy/profile/privacy_profile_local_datasource.dart';
import '../../../datasource/privacy/profile/privacy_profile_remote_datasource.dart';
import '../../../model/privacy/privacy_profile/privacy_profile_model.dart';

class ProfilePrivacyRepositoryImpl implements ProfilePrivacyRepository {
  final ProfilePrivacyRemoteDataSource remoteDataSource;
  final ProfilePrivacyLocalDataSource localDataSource;

  ProfilePrivacyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ProfileEntity> getProfilePrivacy(String userId) async {
    try {
      final remoteModel = await remoteDataSource.getProfilePrivacy(userId);
      await localDataSource.cacheProfilePrivacy(remoteModel);
      return remoteModel.toEntity();

    } catch (e) {
      final cached = await localDataSource.getCachedProfilePrivacy();
      if (cached != null) {
        return cached.toEntity();

      } else {
        return const ProfileEntity(
          visibility: 'everyone',
          exceptUids: [],
        );
      }
    }
  }

  @override
  Future<void> updateProfilePrivacy(String userId, ProfileEntity entity) async {
    final model = ProfileModel.fromEntity(entity);
    await remoteDataSource.updateProfilePrivacy(userId, model);
    await localDataSource.cacheProfilePrivacy(model);
  }



}
