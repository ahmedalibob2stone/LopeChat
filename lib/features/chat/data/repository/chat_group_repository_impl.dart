


import '../../../group/data/model/group/group.dart';
import '../../../group/domain/entities/group_entity.dart';
import '../../domain/repository/chat_group_repository.dart';
import '../datasorce/chat_group_remote_datasource.dart';

class ChatGroupRepositoryImpl implements ChatGroupRepository {
  final ChatGroupRemoteDataSource remoteDataSource;

  ChatGroupRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Stream<List<GroupEntity>> getChatGroups() {
    return remoteDataSource.getChatGroups().map(
          (groupsModelList) => groupsModelList.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Stream<List<GroupEntity>> searchGroup({required String searchName}) {
    return remoteDataSource.searchGroup(searchName: searchName).map(
          (groupsModelList) => groupsModelList.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<void> archiveGroupChat({
    required String groupId,
    required String userId,
  }) async {
    return await remoteDataSource.archiveGroupChat(groupId: groupId, userId: userId);
  }

  @override
  Future<void> unarchiveGroupChat({
    required String groupId,
    required String userId,
  }) async {
    return await remoteDataSource.unarchiveGroupChat(groupId: groupId, userId: userId);}

  @override
  Stream<List<GroupModel>> getArchivedGroups(String userId) {return remoteDataSource.getArchivedGroups(userId);}

  @override
  Stream<List<GroupModel>> getUnarchivedGroups(String userId) {return  remoteDataSource.getUnarchivedGroups(userId);}


  @override
  Future<void> openGroupChat(String groupId) {
    return remoteDataSource.openGroupChat(groupId);
  }


  @override
  Future<void> markGroupMessagesAsSeen({
    required String groupId,
    required String uid,
  }) {
    return remoteDataSource.markGroupMessagesAsSeen(
      groupId: groupId,
      uid: uid,
    );
  }
  @override
  Future<void> deleteGroupChatMessages({
    required String groupId,}) async{return  remoteDataSource.deleteGroupChatMessages(groupId: groupId);}

}
