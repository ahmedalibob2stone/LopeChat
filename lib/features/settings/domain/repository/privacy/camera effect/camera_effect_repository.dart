abstract class CameraEffectsRepository {
  Future<bool> isEffectsEnabled();
  Future<void> changeEffectsStatus(bool isEnabled);
}