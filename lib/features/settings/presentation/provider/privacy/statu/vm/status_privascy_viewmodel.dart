import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../user/domain/entities/user_entity.dart';
import '../../../../viewmodel/privacy/statu/filter_statu_viewmodel.dart';
import '../../../../viewmodel/privacy/statu/status_privacy_viewmodel.dart';
import '../usecases/get_status_privacy_usecase_provider.dart';
import '../usecases/set_status_privacy_usecase_provider.dart';

final statusPrivacyProvider = StateNotifierProvider.autoDispose<StatusPrivacyViewModel, StatusPrivacyState>(
      (ref) {
    final localContacts = <UserEntity>[];
    final getUseCase = ref.read(getStatusPrivacyUseCaseProvider);
    final setUseCase = ref.read(setStatusPrivacyUseCaseProvider);
    return StatusPrivacyViewModel(
      getUseCase: getUseCase,
      setUseCase: setUseCase,
      localContacts: localContacts,
    );
  },
);


