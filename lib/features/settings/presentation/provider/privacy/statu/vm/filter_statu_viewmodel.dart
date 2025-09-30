import 'package:lopechat/features/settings/presentation/provider/privacy/statu/vm/status_privascy_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../status/presentation/provider/usecases/get_statuses_usecase_provider.dart';
import '../../../../viewmodel/privacy/statu/filter_statu_viewmodel.dart';

  final filterStatusViewModelProvider = StateNotifierProvider<FilterStatuViewmodel, StatusState>((ref) {
    final privacyState = ref.watch(statusPrivacyProvider);
    final getStatusesUseCase = ref.watch(getStatusesUseCaseProvider);

    return FilterStatuViewmodel(ref, privacyState, getStatusesUseCase);
  });
