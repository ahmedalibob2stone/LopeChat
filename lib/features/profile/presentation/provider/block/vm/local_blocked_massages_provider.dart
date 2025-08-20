import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/model/block/local_blocked_massage.dart';

class LocalBlockedMessagesNotifier extends StateNotifier<List<LocalBlockedMessage>> {
  LocalBlockedMessagesNotifier() : super([]);

  void addLocalBlockedMessage(LocalBlockedMessage message) {
    state = [...state, message];
  }

  void clear() {
    state = [];
  }
}

final localBlockedMessagesProvider = StateNotifierProvider<LocalBlockedMessagesNotifier, List<LocalBlockedMessage>>(
      (ref) => LocalBlockedMessagesNotifier(),
);
