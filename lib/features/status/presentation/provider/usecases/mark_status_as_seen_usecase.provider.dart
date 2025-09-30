import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/get_statuses_usecase.dart';
import '../../../domain/usecases/mark_status_as_seen_usecase.dart';
import '../data/provider.dart';

final markStatusAsSeenUseCaseProvider = Provider<MarkStatusAsSeenUseCase>((ref) {
  final repo = ref.read(statusRepositoryImplProvider);
  return MarkStatusAsSeenUseCase( repository: repo);
});
