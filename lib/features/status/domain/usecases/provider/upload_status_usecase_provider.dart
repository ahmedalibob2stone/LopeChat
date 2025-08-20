import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/status_repository_impl.dart';
import '../upload_status_usecase.dart';

final uploadStatusUseCaseProvider = Provider<UploadStatusUseCase>((ref) {
  final repo = ref.read(statusRepositoryImplProvider);
  return UploadStatusUseCase(repo);
});
