import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/model/massage/massage_model.dart';
import '../usecase/provider.dart';

final chatMessagesProvider =
StreamProvider.family<List<MessageModel>, String>((ref, chatId) {
  final usecase = ref.watch(getStreamMessagesUseCaseProvider);

  return usecase.execute(chatId).map(
        (entities) => entities.map((e) => MessageModel.fromEntity(e)).toList(),
  );
});
