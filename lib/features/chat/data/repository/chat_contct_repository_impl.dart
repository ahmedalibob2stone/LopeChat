


import '../../domain/repository/chat_contact_repository.dart';
import '../datasorce/chat_contact_remote_datasource.dart';
import '../model/contact/chat_contact.dart';

class ChatContactRepositoryImpl implements ChatContactRepository {
  final ChatContactRemoteDataSource remoteDataSource;

  ChatContactRepositoryImpl({
    required this.remoteDataSource,
  });


  @override
  Stream<List<ChatContactModel>> searchContact({required String searchName}) {
    return remoteDataSource.searchContact(searchName: searchName);
  }
  @override
  Future<void> archiveChat(String chatId) async {
    return remoteDataSource.archiveChat( id:chatId);
  }
  @override
  Stream<List<ChatContactModel>> getUnarchivedChats() {
    return remoteDataSource.getUnarchivedChats();
  }
  @override
  Stream<List<ChatContactModel>> getArchivedChats() {
    return remoteDataSource.getArchivedChats();
  }
  @override
  Future<void> unarchiveChat(String chatId) async{
    return remoteDataSource.unarchiveChat(chatId);
  }
  @override
  Future<void> deleteChat({
    required String receiverId,
  }) async{  return remoteDataSource.deleteChat(receiverId: receiverId);}
  }
