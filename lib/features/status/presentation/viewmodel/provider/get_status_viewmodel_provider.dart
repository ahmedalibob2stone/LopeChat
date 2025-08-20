
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/provider/get_statuses_usecase_provider.dart';
import '../get_status_viewmodel.dart';

final getStatusesViewModelProvider = StateNotifierProvider<GetStatusesViewModel, StatusListState>((ref) {
  final getStatusesUseCase = ref.read(getStatusesUseCaseProvider); // مزود UseCase
  return GetStatusesViewModel(getStatusesUseCase);
});
