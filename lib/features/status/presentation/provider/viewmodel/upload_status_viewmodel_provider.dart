import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/upload_status_viewmodel.dart';
import '../usecases/upload_status_usecase_provider.dart';

final uploadStatusViewModelProvider =
StateNotifierProvider<UploadStatusViewModel, UploadStatusState>((ref) {
  final useCase = ref.read(uploadStatusUseCaseProvider);
  return UploadStatusViewModel( useCase: useCase);
});
