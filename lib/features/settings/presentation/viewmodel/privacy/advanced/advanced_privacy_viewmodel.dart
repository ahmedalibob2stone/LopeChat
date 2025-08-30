import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/widgets/check internat/check_internat.dart';
import '../../../../domain/usecases/privacy/advanced/get_block_unknown_senders.dart';
import '../../../../domain/usecases/privacy/advanced/get_disable_link_previews_usecase.dart';
import '../../../../domain/usecases/privacy/advanced/get_protect_ip_in_calls_usecase.dart';
import '../../../../domain/usecases/privacy/advanced/set_block_unknown_senders_usecase.dart';
import '../../../../domain/usecases/privacy/advanced/set_disable_link_previews_usecase.dart';
import '../../../../domain/usecases/privacy/advanced/set_protect_ip_in_calls_usecase.dart';



class AdvancedPrivacyState {
  final bool blockUnknownMessages;
  final bool ipProtection;
  final bool disableLinkPreview;
  final String? error;

  AdvancedPrivacyState({
    required this.blockUnknownMessages,
    required this.ipProtection,
    required this.disableLinkPreview,
    this.error,
  });

  factory AdvancedPrivacyState.initial() {
    return AdvancedPrivacyState(
      blockUnknownMessages: false,
      ipProtection: false,
      disableLinkPreview: false,
      error: null,
    );
  }

  AdvancedPrivacyState copyWith({
    bool? blockUnknownMessages,
    bool? ipProtection,
    bool? disableLinkPreview,
    String? error,
  }) {
    return AdvancedPrivacyState(
      blockUnknownMessages: blockUnknownMessages ?? this.blockUnknownMessages,
      ipProtection: ipProtection ?? this.ipProtection,
      disableLinkPreview: disableLinkPreview ?? this.disableLinkPreview,
      error: error,
    );
  }
}

class AdvancedPrivacyViewModel extends StateNotifier<AdvancedPrivacyState> {
  final GetBlockUnknownSendersUseCase getBlockUnknownSendersUseCase;
  final SetBlockUnknownSendersUseCase setBlockUnknownSendersUseCase;

  final GetProtectIpInCallsUseCase getProtectIpInCallsUseCase;
  final SetProtectIpInCallsUseCase setProtectIpInCallsUseCase;

  final GetDisableLinkPreviewsUseCase getDisableLinkPreviewsUseCase;
  final SetDisableLinkPreviewsUseCase setDisableLinkPreviewsUseCase;

  AdvancedPrivacyViewModel({
    required this.getBlockUnknownSendersUseCase,
    required this.setBlockUnknownSendersUseCase,
    required this.getProtectIpInCallsUseCase,
    required this.setProtectIpInCallsUseCase,
    required this.getDisableLinkPreviewsUseCase,
    required this.setDisableLinkPreviewsUseCase,
    required this.checkInternet,
  }) : super(AdvancedPrivacyState.initial());

  final CheckInternet checkInternet;
  Future<void> loadBlockUnknownMessages() async {
    try {
      final result = await getBlockUnknownSendersUseCase.call();
      state = state.copyWith(blockUnknownMessages: result.blockUnknownSenders, error: null);
    } catch (_) {
      state = state.copyWith(error: 'فشل تحميل حالة حظر الرسائل');
    }
  }

  // تحميل قيمة ipProtection من SharedPreferences
  Future<void> loadIpProtection() async {
    try {
      final value = await getProtectIpInCallsUseCase.call();
      state = state.copyWith(ipProtection: value, error: null);
    } catch (_) {
      state = state.copyWith(error: 'فشل تحميل حالة حماية الـ IP');
    }
  }

  Future<void> loadDisableLinkPreview() async {
    try {
      final value = await getDisableLinkPreviewsUseCase.call();
      state = state.copyWith(disableLinkPreview: value, error: null);
    } catch (_) {
      state = state.copyWith(error: 'فشل تحميل حالة تعطيل معاينات الروابط');
    }
  }

  // دوال التبديل (toggle) مع إدارة الخطأ كما عندك
  Future<void> toggleBlockUnknownMessages(bool value) async {
    final hasInternet = await checkInternet.IsConnected();
    if (!hasInternet) {
      state = state.copyWith(error: 'الشبكة غير متاحة الرجاء المحاولة لاحقًا');
      return;
    }

    try {
      await setBlockUnknownSendersUseCase.call(value);
      state = state.copyWith(blockUnknownMessages: value, error: null);
    } catch (_) {
   //   state = state.copyWith(error: 'فشل تحديث حالة حظر الرسائل');
    }
  }

  Future<void> toggleIpProtection(bool value) async {
    await setProtectIpInCallsUseCase.call(value);
    state = state.copyWith(ipProtection: value, error: null);
  }

  Future<void> toggleDisableLinkPreview(bool value) async {
    await setDisableLinkPreviewsUseCase.call(value);
    state = state.copyWith(disableLinkPreview: value, error: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
