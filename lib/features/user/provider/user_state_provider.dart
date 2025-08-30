import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/usecases/provider/setuser_state_Provider.dart';
import '../viewmodel/user_state_viewmodel.dart';

final userStateViewModelProvider =
StateNotifierProvider<UserStateViewModel, AsyncValue<void>>((ref) {
  final useCase = ref.read(setUserStateUseCaseProvider);
  return UserStateViewModel(setUserStateUseCase: useCase);
});