import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/provider/delet_statuses_usecase_provider.dart';
import '../delet_status_viewmodel.dart';

final deleteStatusViewModelProvider =
StateNotifierProvider<DeleteStatusViewModel, DeleteStatusState>((ref) {
  final deleteUseCase = ref.read(deleteStatusUseCaseProvider);
  return DeleteStatusViewModel(deleteUseCase);
});
