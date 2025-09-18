import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/chat message/local_blocked_massage.dart';

class LocalBlockedMessagesNotifier extends StateNotifier<List<LocalBlockedMessage>> {
  LocalBlockedMessagesNotifier() : super([]);

  void addLocalBlockedMessage(LocalBlockedMessage message) {
    state = [...state, message];
  }

  void clear() {
    state = [];
  }
}
