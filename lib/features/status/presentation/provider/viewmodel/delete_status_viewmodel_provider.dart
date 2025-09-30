import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/delet_status_viewmodel.dart';
import '../usecases/delet_statuses_usecase_provider.dart';

final deleteStatusViewModelProvider =
StateNotifierProvider<DeleteStatusViewModel, DeleteStatusState>((ref) {
  final deleteUseCase = ref.read(deleteStatusUseCaseProvider);
  return DeleteStatusViewModel(deleteUseCase);
});
