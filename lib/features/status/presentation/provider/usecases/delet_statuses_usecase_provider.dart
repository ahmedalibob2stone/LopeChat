import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/delet_statuses_usecase.dart';
import '../data/provider.dart';
final deleteStatusUseCaseProvider = Provider<DeleteStatusUseCase>((ref) {
  final repo = ref.read(statusRepositoryImplProvider);
  return DeleteStatusUseCase(repo);
});

