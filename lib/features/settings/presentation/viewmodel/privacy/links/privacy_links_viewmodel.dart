import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../common/widgets/check internat/check_internat.dart';
import '../../../../domain/entities/privacy/links/links_privacy_entity.dart';
import '../../../../domain/usecases/privacy/links/get_links_privacy_usecase.dart';
import '../../../../domain/usecases/privacy/links/update_links_privacy_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LinksPrivacyState extends Equatable {
  final bool isLoading;
  final String visibility;
  final List<String> exceptUids;
  final String? error;
  final String? message;   // رسالة للسناك بار (نجاح أو خطأ)

  const LinksPrivacyState({
    this.isLoading = false,
    this.visibility = 'everyone',
    this.exceptUids = const [],
    this.error,
    this.message,
  });

  LinksPrivacyState copyWith({
    bool? isLoading,
    String? visibility,
    List<String>? exceptUids,
    String? error,
    String? message,
  }) {
    return LinksPrivacyState(
      isLoading: isLoading ?? this.isLoading,
      visibility: visibility ?? this.visibility,
      exceptUids: exceptUids ?? this.exceptUids,
      error: error,
      message: message,
    );
  }

  @override
  List<Object?> get props => [isLoading, visibility, exceptUids, error, message];
}


class LinksPrivacyViewModel extends StateNotifier<LinksPrivacyState> {
  final GetLinksPrivacyUseCase getUseCase;
  final UpdateLinksPrivacyUseCase setUseCase;

  LinksPrivacyViewModel({
    required this.getUseCase,
    required this.setUseCase,
  }) : super(const LinksPrivacyState()) {
    loadLinksPrivacy();
  }

  Future<void> loadLinksPrivacy() async {
    state = state.copyWith(isLoading: true, error: null, message: null);

    try {
      final entity = await getUseCase();
      if (entity != null) {
        state = state.copyWith(
          isLoading: false,
          visibility: entity.visibility,
          exceptUids: entity.exceptUids,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateVisibility(String newVisibility) {
    state = state.copyWith(visibility: newVisibility, message: null, error: null);
  }

  void updateExceptUids(List<String> newExceptUids) {
    state = state.copyWith(exceptUids: newExceptUids, message: null, error: null);
  }

  Future<void> saveLinksPrivacy() async {
    state = state.copyWith(isLoading: true, error: null, message: null);

    final connected = await CheckInternet.isConnected();

    if (!connected) {
      state = state.copyWith(
          isLoading: false,
          error: 'لا يوجد اتصال بالإنترنت. الرجاء المحاولة لاحقاً.',
          message: null);
      return;
    }

    try {
      final entity = LinksPrivacyEntity(
        visibility: state.visibility,
        exceptUids: state.exceptUids,
      );
      await setUseCase(entity);

      state = state.copyWith(
        isLoading: false,
        message: 'تم تحديث إعدادات الخصوصية بنجاح.',
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'حدث خطأ أثناء تحديث الخصوصية.',
        message: null,
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(message: null, error: null);
  }
  Future<void> updateLinksPrivacy(String visibility, [List<String>? exceptUids]) async {
    updateVisibility(visibility);
    if (exceptUids != null) {
      updateExceptUids(exceptUids);
    }
    await saveLinksPrivacy();
  }
}

