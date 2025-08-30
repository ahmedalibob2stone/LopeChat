

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/call_history_viewmodel.dart';
import '../../viewmodel/call_picker_viewmodel.dart';
import '../../viewmodel/call_session_viewmodel.dart';
import '../../viewmodel/craete_call_viewmodel.dart';
import '../usecase/provider.dart';

final createCallViewModelProvider =
StateNotifierProvider<CreateCallViewModel, CallCreateState>((ref) {
  final createCallUseCase = ref.watch(createCallUseCaseProvider);
  final makeGroupCallUseCase = ref.watch(makeGroupCallUseCaseProvider);

  return CreateCallViewModel(
    createCallUseCase: createCallUseCase,
    makeGroupCallUseCase: makeGroupCallUseCase,
    ref: ref,
  );
});

final callPickupViewModelProvider =
StateNotifierProvider<CallPickupViewModel, CallPickupState>((ref) {
  final useCase = ref.watch(callStreamUseCaseProvider);
  return CallPickupViewModel(callUsecase: useCase);
});

final callSessionViewModelProvider = StateNotifierProvider<CallSessionViewModel, CallState>((ref) {
  final endcallprovider =ref.watch(endCallUseCaseProvider);
  return CallSessionViewModel( endCallUseCase:endcallprovider);
});



final incomingCallProvider = StreamProvider<DocumentSnapshot>((ref) {
  final useCase = ref.watch(callStreamUseCaseProvider);
  return useCase.callStream;
});
final callHistoryViewModelProvider =
StateNotifierProvider<CallHistoryViewModel, CallHistoryState>((ref) {
  final getStreamCallsUseCase = ref.watch(getStreamCallsUseCaseProvider);
  final deleteCallUseCase = ref.watch(deleteCallUseCaseProvider);
  return CallHistoryViewModel(
    getStreamCallsUseCase: getStreamCallsUseCase,
    deleteCallUseCase: deleteCallUseCase,
  );
});