import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/get_statuses_usecase.dart';
import '../data/provider.dart';

final getStatusesUseCaseProvider = Provider<GetStatusesUseCase>((ref) {
  final repo = ref.read(statusRepositoryImplProvider);
  return GetStatusesUseCase(repo);
});
