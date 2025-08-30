import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodel/privacy/read receipts/read_receipts_viewmodel.dart';
import '../usecases/provider.dart';
final readReceiptsViewModelProvider = StateNotifierProvider<ReadReceiptsViewModel, ReadReceiptsState>((ref) {
  final get = ref.read(getReadReceiptsUseCaseProvider);
  final update = ref.read(updateReadReceiptsUseCaseProvider);
  return ReadReceiptsViewModel(get, update);
});
