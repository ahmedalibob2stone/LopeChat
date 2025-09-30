import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/upload_status_usecase.dart';
import '../data/provider.dart';

final uploadStatusUseCaseProvider = Provider<UploadStatusUseCase>((ref) {
  final repo = ref.read(statusRepositoryImplProvider);
  return UploadStatusUseCase(repo);
});
