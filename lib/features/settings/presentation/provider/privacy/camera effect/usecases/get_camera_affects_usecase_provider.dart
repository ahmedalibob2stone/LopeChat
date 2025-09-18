
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../main.dart';
import '../../../../../data/datasource/privacy/camera effect/camera_effect_datasource.dart';
import '../../../../../data/datasource/privacy/camera effect/camera_effect_datasource_impl.dart';
import '../../../../../data/repository/privacy/camera effects/camera_effect_repository_impl.dart';
import '../../../../../domain/repository/privacy/camera effect/camera_effect_repository.dart';
import '../../../../../domain/usecases/privacy/camera effect/get_camera_effects_usecase.dart';

final cameraEffectsDataSourceProvider = Provider<CameraEffectsDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return CameraEffectsDataSourceImpl(sharedPreferences);
});

final cameraEffectsRepositoryProvider = Provider<CameraEffectsRepository>((ref) {
  final dataSource = ref.watch(cameraEffectsDataSourceProvider);
  return CameraEffectsRepositoryImpl(dataSource);
});

final getCameraEffectsStatusUseCaseProvider = Provider<GetCameraEffectsStatusUseCase>((ref) {
  final repository = ref.watch(cameraEffectsRepositoryProvider);
  return GetCameraEffectsStatusUseCase(repository);
});