

import '../../../../domain/repository/privacy/camera effect/camera_effect_repository.dart';
import '../../../datasource/privacy/camera effect/camera_effect_datasource.dart';

class CameraEffectsRepositoryImpl implements CameraEffectsRepository {
  final CameraEffectsDataSource dataSource;

  CameraEffectsRepositoryImpl(this.dataSource);

  @override
  Future<bool> isEffectsEnabled() => dataSource.getEffectsStatus();

  @override
  Future<void> changeEffectsStatus(bool isEnabled) => dataSource.setEffectsStatus(isEnabled);
}
