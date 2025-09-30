import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/contact_entities.dart';
import '../../../domain/usecase/chat_contact/get_chat_contact_usecase.dart';

class ChatContactState {
  final bool isLoading;
  final String? error;
  final List<ChatContactEntity> chats;

  ChatContactState({
    this.isLoading = false,
    this.error,
    this.chats = const [],
  });

  ChatContactState copyWith({
    bool? isLoading,
    String? error,
    List<ChatContactEntity>? chats,
  }) {
    return ChatContactState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      chats: chats ?? this.chats,
    );
  }
}

class ChatContactViewModel extends StateNotifier<ChatContactState> {
  final GetChatContactsUseCase getChatContactsUseCase;
  Stream<List<ChatContactEntity>>? _chatStream;
  StreamSubscription<List<ChatContactEntity>>? _subscription;

  ChatContactViewModel({required this.getChatContactsUseCase})
      : super(ChatContactState());

  void loadChats({required String userId}) {
    state = state.copyWith(isLoading: true, error: null);

    _chatStream = getChatContactsUseCase(userId: userId);

    _subscription = _chatStream!.listen(
          (chatList) {
        print("✅ Chats received: ${chatList.length}");
        state = state.copyWith(isLoading: false, chats: chatList);
      },
      onError: (err) {
        print("❌ Error in chat stream: $err");
        state = state.copyWith(isLoading: false, error: err.toString());
      },
      onDone: () {
        print("⚠️ Chat stream closed");
        state = state.copyWith(isLoading: false);
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
