import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../domain/usecase/chat_config/get_disappearing_messages.dart';
import '../../../../domain/usecase/chat_config/toggle_disappearing_messages.dart';
import '../data/provider.dart';

final toggleDisappearingMessagesUseCaseProvider = Provider<ToggleDisappearingMessagesUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ToggleDisappearingMessagesUseCase(repository);
});

final getDisappearingMessagesConfigUseCaseProvider = Provider<GetDisappearingMessagesConfigUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return GetDisappearingMessagesConfigUseCase(repository);
});
