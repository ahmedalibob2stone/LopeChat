

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/get_my_data_stream_usecase.dart';
import '../repository/repository_provider.dart';

  final getMyDataStreamUseCaseProvider = Provider<GetMyDataStreamUseCase>((ref) {
    final repository = ref.read(userRepositoryProvider);
    return GetMyDataStreamUseCase(repository);
  });