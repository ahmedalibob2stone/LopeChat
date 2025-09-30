


import '../entities/contact_entities.dart';

abstract class ChatContactRepository {
  Stream<List<ChatContactEntity>> searchContact({required String searchName});
  Future<void> archiveChat(String chatId);
  Stream<List<ChatContactEntity>> getUnarchivedChats();
  Stream<List<ChatContactEntity>> getArchivedChats();
  Future<void> unarchiveChat(String chatId);
  Future<void> deleteChat({
    required String receiverId,
  }) async{}
  Stream<List<ChatContactEntity>> getChatContacts({required String userId});
}
