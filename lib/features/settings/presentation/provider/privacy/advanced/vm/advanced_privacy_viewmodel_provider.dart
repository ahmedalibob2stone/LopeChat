import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/widgets/check internat/check_internat.dart';
import '../../../../viewmodel/privacy/advanced/advanced_privacy_viewmodel.dart';
import '../usecases/get_block_unknown_senders_usecase_provider.dart';
import '../usecases/get_disable_link_previews_usecase_provider.dart';
import '../usecases/get_protect_ip_in_calls_usecase_usecase.dart';
import '../usecases/set_block_unknown_senders_usecase_provider.dart';
import '../usecases/set_disable_link_previews_usecase_provider.dart';
import '../usecases/set_protect_ip_in_calls_usecase_provider.dart';

final advancedPrivacyViewModelProvider =
StateNotifierProvider<AdvancedPrivacyViewModel, AdvancedPrivacyState>((ref) {
  final setBlockUnknownSendersUseCase = ref.read(setBlockUnknownSendersUseCaseProvider);
  final getBlockUnknownSendersUseCase = ref.read(getBlockUnknownSendersUseCaseProvider);

  final setProtectIpInCallsUseCase = ref.read(setProtectIpInCallsUseCaseProvider);
  final getProtectIpInCallsUseCase = ref.read(getProtectIpInCallsUseCaseProvider);

  final setDisableLinkPreviewsUseCase = ref.read(setDisableLinkPreviewsUseCaseProvider);
  final getDisableLinkPreviewsUseCase = ref.read(getDisableLinkPreviewsUseCaseProvider);

  return AdvancedPrivacyViewModel(
    setBlockUnknownSendersUseCase: setBlockUnknownSendersUseCase,
    getBlockUnknownSendersUseCase: getBlockUnknownSendersUseCase,
    setProtectIpInCallsUseCase: setProtectIpInCallsUseCase,
    getProtectIpInCallsUseCase: getProtectIpInCallsUseCase,
    setDisableLinkPreviewsUseCase: setDisableLinkPreviewsUseCase,
    getDisableLinkPreviewsUseCase: getDisableLinkPreviewsUseCase, checkInternet: ref.read(CheckInternetProvider)
  );
  //CheckInternetProvider
});
