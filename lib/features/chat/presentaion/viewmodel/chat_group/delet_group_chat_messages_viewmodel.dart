import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/chat_group_usecase/delete_group_chat_messages_usecase.dart';


class DeleteGroupChatState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  DeleteGroupChatState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  DeleteGroupChatState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return DeleteGroupChatState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  factory DeleteGroupChatState.initial() => DeleteGroupChatState();
}
class DeleteGroupChatMessagesViewModel extends StateNotifier<DeleteGroupChatState> {
  final DeleteGroupChatMessagesUseCase deleteGroupChatUseCase;

  DeleteGroupChatMessagesViewModel({required this.deleteGroupChatUseCase}) : super(DeleteGroupChatState.initial());

  Future<void> deleteGroupChat(String groupId) async {
    try {
      state = state.copyWith(isLoading: true, isSuccess: false, errorMessage: null);

      await deleteGroupChatUseCase.execute(groupId:groupId);

      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, isSuccess: false, errorMessage: e.toString());
    }
  }

  void reset() {
    state = DeleteGroupChatState.initial();
  }
}