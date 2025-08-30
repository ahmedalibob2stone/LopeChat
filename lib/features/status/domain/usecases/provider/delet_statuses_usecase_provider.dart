import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/status_repository_impl.dart';
import '../delet_statuses_usecase.dart';
final deleteStatusUseCaseProvider = Provider<DeleteStatusUseCase>((ref) {
  final repo = ref.read(statusRepositoryImplProvider);
  return DeleteStatusUseCase(repo);
});

