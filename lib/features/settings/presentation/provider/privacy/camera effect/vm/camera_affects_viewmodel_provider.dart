import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodel/privacy/camera effect/camera_effects_viewmodel.dart';
import '../usecases/get_camera_affects_usecase_provider.dart';
import '../usecases/set_camera_affects_usecase_provider.dart';

final cameraEffectsViewModelProvider = StateNotifierProvider<CameraEffectsViewModel, CameraEffectsState>((ref) {
  final getUseCase = ref.watch(getCameraEffectsStatusUseCaseProvider);
  final setUseCase = ref.watch(setCameraEffectsStatusUseCaseProvider);
  return CameraEffectsViewModel(getUseCase: getUseCase, setUseCase: setUseCase);
});
final cameraEffectsEnabledProvider = Provider<bool>((ref) {
  final state = ref.watch(cameraEffectsViewModelProvider);
  return state.isEnabled;
});
final ipProtectionEnabledProvider = Provider<bool>((ref) {
  final state = ref.watch(cameraEffectsViewModelProvider);
  return state.isEnabled;
});
