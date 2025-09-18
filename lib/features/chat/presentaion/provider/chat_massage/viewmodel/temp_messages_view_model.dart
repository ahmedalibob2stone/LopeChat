import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../viewmodel/chat_massage/temp_messages_viewmodel.dart';

final tempMessageProvider =
StateNotifierProvider<TempMessageNotifier, List<TempMessage>>(
      (ref) => TempMessageNotifier(),
);