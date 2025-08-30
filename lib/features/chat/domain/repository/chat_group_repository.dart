

import '../../../group/domain/entities/group_entity.dart';

abstract class ChatGroupRepository {
  Stream<List<GroupEntity>> getChatGroups();

  Stream<List<GroupEntity>> searchGroup({required String searchName});


  Future<void> openGroupChat(String groupId);


  Future<void> markGroupMessagesAsSeen({
    required String groupId,
    required String uid,
  });


  Future<void> archiveGroupChat({
    required String groupId,
    required String userId,
  });

  Future<void> unarchiveGroupChat({
    required String groupId,
    required String userId,
  });

  Stream<List<GroupEntity>> getArchivedGroups(String userId);

  Stream<List<GroupEntity>> getUnarchivedGroups(String userId);
  Future<void> deleteGroupChatMessages({
    required String groupId,
  });
}
