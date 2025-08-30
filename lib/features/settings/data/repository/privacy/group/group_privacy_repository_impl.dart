

import '../../../../domain/entities/privacy/group/group_privacy_entity.dart';
import '../../../../domain/repository/privacy/group/group_privacy_repository.dart';
import '../../../datasource/privacy/group/group_privacy_remote_datasource.dart';
import '../../../model/privacy/group/group_privacy_model.dart';

class GroupPrivacyRepositoryImpl implements GroupPrivacyRepository {
  final GroupPrivacyRemoteDataSource remoteDataSource;

  GroupPrivacyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GroupPrivacyEntity> getGroupPrivacy(String uid) async {
    final model = await remoteDataSource.getGroupPrivacy(uid);
    return GroupPrivacyEntity(
      visibility: model.visibility,
      exceptUids: model.exceptUids,
    );
  }

  @override
  Future<void> updateGroupPrivacy(GroupPrivacyEntity entity,String uid) async {
    final model = GroupPrivacyModel.fromEntity(entity);
    await remoteDataSource.updateGroupPrivacy(model,uid);
  }
}
