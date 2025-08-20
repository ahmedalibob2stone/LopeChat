import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entites/callentites.dart';
import '../../domain/usecase/create_call_usecase.dart';
import '../../domain/usecase/mke_group_call_usecase.dart';



class CreateCallViewModel extends StateNotifier<AsyncValue<void>> {
  final CreateCallUseCase createcallUseCases;
  final MakeGroupCallUseCase makeGroupCallUseCase;
  final Ref ref;

  CreateCallViewModel({required this.createcallUseCases,required this.makeGroupCallUseCase, required this.ref}) : super(const AsyncData(null));

  Future<void> createCall({
    required BuildContext context,
    required CallEntites senderCall,
    required CallEntites receiverCall,
    required bool isGroupChat,
  }) async {
    state = const AsyncLoading();
    try {
      if (isGroupChat) {
        await makeGroupCallUseCase.call(senderCall, receiverCall);
      } else {
        await createcallUseCases.call(senderCall, receiverCall);
      }
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
