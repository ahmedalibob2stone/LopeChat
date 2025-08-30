import '../../../repository/privacy/camera effect/camera_effect_repository.dart';

class GetCameraEffectsStatusUseCase {
  final CameraEffectsRepository repository;

  GetCameraEffectsStatusUseCase(this.repository);

  Future<bool> call() {
    return repository.isEffectsEnabled();
  }
}