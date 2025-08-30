

import '../../../entities/privacy/group/group_privacy_entity.dart';

abstract class GroupPrivacyRepository{
   Future<GroupPrivacyEntity> getGroupPrivacy(String uid) ;
    Future<void> updateGroupPrivacy(GroupPrivacyEntity entity,String uid);
}