abstract class CameraEffectsDataSource  {
  Future<bool> getEffectsStatus();
  Future<void> setEffectsStatus(bool isEnabled);
}
