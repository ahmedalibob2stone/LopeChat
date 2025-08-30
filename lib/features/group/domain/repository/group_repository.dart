import 'dart:io';

import 'package:flutter_contacts/contact.dart';

import '../entities/group_entity.dart';

abstract class IGroupRepository {
  Future<void> createGroup({
    required String name,
    required File profile,
    required List<Contact> selectedContacts,
  });
  Future<GroupEntity> getGroupById(String groupId);
  Future<void> deleteGroup(String groupId) ;

  Stream<GroupEntity> getGroupData(String groupId);


  Future<void> addUsersToGroup({required List<Contact> selectedContacts, required String groupId,});
  Future<void> deleteMemberFromGroup({required String groupId, required String memberId,});
  Future<String> getAdminUid(String groupId);
  Future<String?> getUserIdByPhone(String phoneNumber);
  Future<void> addAdmin(String groupId, String userIdToAdd);
  Future<void> removeAdmin(String groupId, String userIdToRemove);
  Future<void> leaveGroup(String groupId);
  Future<void> updateGroupNameAndImage({required String groupId, String? newName, File? newProfileImage,});

}

