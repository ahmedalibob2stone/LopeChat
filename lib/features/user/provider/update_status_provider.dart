import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/usecases/provider/add_status_provider.dart';
import '../viewmodel/update_status_viewmodel.dart';

final updateStatusViewModelProvider =
StateNotifierProvider<UpdateStatusViewModel, AsyncValue<void>>((ref) {
  final useCase = ref.read(addStatusUseCaseProvider);
  return UpdateStatusViewModel(addStatusUseCase: useCase);
});
