
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/user_repository.dart';
import '../get_myDataStream_UseCase.dart';

final getMyDataStreamUseCaseProvider = Provider<GetMyDataStreamUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider); // من data layer
  return GetMyDataStreamUseCase(repo);
});
