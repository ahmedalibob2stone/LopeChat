import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/chat_config_entity.dart';
import '../../domain/repository/chat_config_repository.dart';
import '../datasorce/chat_config_remote_data_source.dart';



class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({ required this.remoteDataSource });

  @override
  Future<void> toggleDisappearingMessages({
    required String chatId,
    required bool isEnabled,
    required int durationSeconds,
  }) {
    return remoteDataSource.toggleDisappearingMessages(
      chatId: chatId,
      isEnabled: isEnabled,
      durationSeconds: durationSeconds,
    );
  }

  @override
  Stream<DisappearingMessagesConfigEntity> getDisappearingMessagesConfig(String chatId) {
    return remoteDataSource.getDisappearingMessagesConfig(chatId).map((configModel) {
      return DisappearingMessagesConfigEntity(
        isEnabled: configModel.isEnabled,
        durationSeconds: configModel.durationSeconds,
      );
    });
  }
}
