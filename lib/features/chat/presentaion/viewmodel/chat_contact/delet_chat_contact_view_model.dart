import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/chat_contact/delete_chat_usecase.dart';

class DeleteChatState {
  final bool isLoading;
  final String? error;

  DeleteChatState({this.isLoading = false, this.error});
}

class DeleteChatViewModel extends StateNotifier<DeleteChatState> {
  final DeleteChatUseCase deleteChatUseCase;

  DeleteChatViewModel(this.deleteChatUseCase) : super(DeleteChatState());

  Future<void> deleteChat({required String receiverId}) async {
    try {
      state = DeleteChatState(isLoading: true);
      await deleteChatUseCase(receiverId:receiverId);
      state = DeleteChatState(isLoading: false);
    } catch (e) {
      state = DeleteChatState(isLoading: false, error: e.toString());
    }
  }
}
