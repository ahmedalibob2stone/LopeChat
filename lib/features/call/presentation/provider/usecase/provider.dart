
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/call_stream_usecase.dart';
import '../../../domain/usecase/create_call_usecase.dart';
import '../../../domain/usecase/delete_call_use_case.dart';
import '../../../domain/usecase/end_call_use_case.dart';
import '../../../domain/usecase/end_group_call_use_case.dart';
import '../../../domain/usecase/get_call_list_use_case.dart';
import '../../../domain/usecase/get_stream_calls_usecase.dart';
import '../../../domain/usecase/mke_group_call_usecase.dart';
import '../datasorce/provider.dart';

final createCallUseCaseProvider = Provider<CreateCallUseCase>((ref) {
  return CreateCallUseCase(ref.watch(callRepositoryProvider));
});

final makeGroupCallUseCaseProvider = Provider<MakeGroupCallUseCase>((ref) {
  return MakeGroupCallUseCase(ref.watch(callRepositoryProvider));
});

final endCallUseCaseProvider = Provider<EndCallUseCase>((ref) {
  return EndCallUseCase(ref.watch(callRepositoryProvider));
});

final endGroupCallUseCaseProvider = Provider<EndGroupCallUseCase>((ref) {
  return EndGroupCallUseCase(ref.watch(callRepositoryProvider));
});

final getCallListUseCaseProvider = Provider<GetCallListUseCase>((ref) {
  return GetCallListUseCase(ref.watch(callRepositoryProvider));
});

final deleteCallUseCaseProvider = Provider<DeleteCallUseCase>((ref) {
  return DeleteCallUseCase(ref.watch(callRepositoryProvider));
});
final getStreamCallsUseCaseProvider = Provider<GetStreamCallsUseCase>((ref) {
  final repo = ref.watch(callRepositoryProvider);
  return GetStreamCallsUseCase(repo);
});
//CallStreamUsecase

final callStreamUseCaseProvider = Provider<CallStreamUsecase>((ref) {
  final repository = ref.watch(callRepositoryProvider);
  return CallStreamUsecase(repository);
});
