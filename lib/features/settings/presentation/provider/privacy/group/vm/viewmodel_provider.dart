import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/widgets/check internat/check_internat.dart';
import '../../../../viewmodel/privacy/group/group_privacy_viewmodel.dart';
import '../usecases/get_group_usecase_provuider.dart';
import '../usecases/update_group_usecase_provider.dart';

final groupPrivacyViewModelProvider = StateNotifierProvider<GroupPrivacyViewModel, GroupPrivacyState>(
      (ref) => GroupPrivacyViewModel(
    getGroupPrivacyUseCase: ref.read(GetGroupPrivacyUseCaseProvider),
    updateGroupPrivacyUseCase: ref.read(UpdateGroupPrivacyUseCaseProvider),
        networkChecker:ref.read(CheckInternetProvider),

  ),
);