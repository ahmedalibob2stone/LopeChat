
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/get_status_viewmodel.dart';
import '../usecases/get_statuses_usecase_provider.dart';

final getStatusesViewModelProvider = StateNotifierProvider<GetStatusesViewModel, StatusListState>((ref) {
  final getStatusesUseCase = ref.read(getStatusesUseCaseProvider); // مزود UseCase
  return GetStatusesViewModel(getStatusesUseCase);
});
