import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/status_repository_impl.dart';
import '../../../repository/status_repository.dart';
import '../get_statuses_usecase.dart';

final getStatusesUseCaseProvider = Provider<GetStatusesUseCase>((ref) {
  final repo = ref.read(statusRepositoryImplProvider);
  return GetStatusesUseCase(repo);
});
