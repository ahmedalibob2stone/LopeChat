import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../entities/chat_config_entity.dart';
import '../../repository/chat_config_repository.dart';


class GetDisappearingMessagesConfigUseCase {
  final ChatRepository repository;

  GetDisappearingMessagesConfigUseCase(this.repository);

  Stream<DisappearingMessagesConfigEntity> call(String chatId) {
    return repository.getDisappearingMessagesConfig(chatId);
  }
}
