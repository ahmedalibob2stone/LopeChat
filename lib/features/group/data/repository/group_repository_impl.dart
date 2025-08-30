import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/contact.dart';

import '../../domain/entities/group_entity.dart';
import '../../domain/repository/group_repository.dart';
import '../datasource/group_remote_data_source.dart';
import '../model/group/group.dart';


class GroupRepositoryImpl implements IGroupRepository {
  final FirebaseFirestore firestore;

  final GroupRemoteDataSource remoteDataSource;

  GroupRepositoryImpl({
    required this.remoteDataSource,
    required this.firestore
  });

  @override
  Future<void> createGroup({
    required String name,
    required File profile,
    required List<Contact> selectedContacts,
  }) async {
    return await remoteDataSource.createGroup(name, profile, selectedContacts);
  }
  @override
  Future<GroupEntity> getGroupById(String groupId) async{
    final groupModel = await remoteDataSource.getGroupById(groupId);
    return groupModel.toEntity();
  }
  @override
  Future<void> deleteGroup(String groupId) async{}

  @override
  Stream<GroupEntity> getGroupData(String groupId) {
    return remoteDataSource.getGroupData(groupId).map(
          (groupModel) => groupModel.toEntity(),
    );
  }

  @override

  Future<void> addUsersToGroup({required List<Contact> selectedContacts, required String groupId,}) async {
    return await remoteDataSource.addUsersToGroup(selectedContacts, groupId);
  }

  @override
  Future<void> deleteMemberFromGroup({required String groupId, required String memberId,}) async {
    return await remoteDataSource.deleteMemberFromGroup(groupId, memberId);
  }

  @override
  Future<String> getAdminUid(String groupId) {
    return remoteDataSource.getAdminUid(groupId);
  }

  @override
  Future<String?> getUserIdByPhone(String phoneNumber) async{
    return remoteDataSource.getUserIdByPhone(phoneNumber);
  }

  @override
  Future<void> addAdmin(String groupId, String userIdToAdd) {
    return remoteDataSource.addAdmin(groupId, userIdToAdd);
  }

  @override
  Future<void> removeAdmin(String groupId, String userIdToRemove) {
    return remoteDataSource.removeAdmin(groupId, userIdToRemove);
  }

  Future<void> leaveGroup(String groupId) async{
    return remoteDataSource.leaveGroup(groupId);
  }

  @override
  Future<void> updateGroupNameAndImage({required String groupId, String? newName, File? newProfileImage,
  }) {
    return remoteDataSource.updateGroupNameAndImage(
      groupId: groupId,
      newName: newName,
      newProfileImage: newProfileImage,
    );
  }
  }