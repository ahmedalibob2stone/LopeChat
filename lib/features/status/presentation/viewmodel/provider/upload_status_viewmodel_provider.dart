import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/provider/upload_status_usecase_provider.dart';
import '../upload_status_viewmodel.dart';

final uploadStatusViewModelProvider =
StateNotifierProvider<UploadStatusViewModel, UploadStatusState>((ref) {
  final useCase = ref.read(uploadStatusUseCaseProvider);
  return UploadStatusViewModel(useCase, ref);
});
