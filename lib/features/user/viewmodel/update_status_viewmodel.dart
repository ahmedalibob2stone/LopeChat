// features/user/presentation/viewmodel/update_status_viewmodel.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/usecases/add_status_UseCase.dart';
import '../domain/usecases/provider/add_status_provider.dart';

class UpdateStatusViewModel extends StateNotifier<AsyncValue<void>> {
  final AddStatusUseCase addStatusUseCase;

  UpdateStatusViewModel({required this.addStatusUseCase})
      : super(const AsyncValue.data(null));

  Future<void> updateStatus(String status) async {
    try {
      state = const AsyncValue.loading();
      await addStatusUseCase(status);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
