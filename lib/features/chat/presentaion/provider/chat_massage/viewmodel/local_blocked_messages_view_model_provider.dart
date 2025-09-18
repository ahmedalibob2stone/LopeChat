
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/chat message/local_blocked_massage.dart';
import '../../../viewmodel/chat_massage/local_blocked_message.dart';

final localBlockedMessagesProvider = StateNotifierProvider<LocalBlockedMessagesNotifier, List<LocalBlockedMessage>>(
      (ref) => LocalBlockedMessagesNotifier(),
);
