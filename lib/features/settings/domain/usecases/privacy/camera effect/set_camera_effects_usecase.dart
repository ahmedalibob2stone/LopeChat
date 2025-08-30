

import '../../../repository/privacy/camera effect/camera_effect_repository.dart';

class SetCameraEffectsStatusUseCase {
  final CameraEffectsRepository repository;

  SetCameraEffectsStatusUseCase(this.repository);

  Future<void> call(bool isEnabled) {
    return repository.changeEffectsStatus(isEnabled);
  }
}
