import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/widgets/check internat/check_internat.dart';
import '../../viewmodel/status_interaction_viewmodel.dart';
import '../usecases/delet_statuses_usecase_provider.dart';
import '../usecases/mark_status_as_seen_usecase.provider.dart';


final statusInteractionsViewModelProvider =
StateNotifierProvider<StatusInteractionsViewModel, StatusInteractionsState>((ref) {
  final markAsSeenUseCase = ref.read(markStatusAsSeenUseCaseProvider);
  final deleteStatusUseCase = ref.read(deleteStatusUseCaseProvider);
  final checkInternet = ref.read(CheckInternetProvider);

  return StatusInteractionsViewModel(
    markStatusAsSeenUseCase: markAsSeenUseCase,
    deleteStatusUseCase: deleteStatusUseCase,
    checkInternet: checkInternet,
  );
});
