import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../data/model/privacy/bout/privacy_about_model.dart';
import '../../../../domain/entities/privacy/about/privacy_about_entity.dart';
import '../../../../domain/usecases/privacy/about/get_about_privacy_usecase.dart';
import '../../../../domain/usecases/privacy/about/update_about_privacy_usecase.dart';


class AboutPrivacyState {
  final bool isLoading;
  final String visibility;
  final List<String> exceptUids;
  final String? errorMessage;
  final String? successMessage;

  AboutPrivacyState({
    this.isLoading = false,
    this.visibility = 'everyone',
    this.exceptUids = const [],
    this.errorMessage,
    this.successMessage,
  });

  AboutPrivacyState copyWith({
    bool? isLoading,
    String? visibility,
    List<String>? exceptUids,
    String? errorMessage,
    String? successMessage,
  }) {
    return AboutPrivacyState(
      isLoading: isLoading ?? this.isLoading,
      visibility: visibility ?? this.visibility,
      exceptUids: exceptUids ?? this.exceptUids,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class AboutPrivacyViewModel extends StateNotifier<AboutPrivacyState> {
  final UpdateAboutPrivacyUseCase updateUseCase;
  final GetAboutPrivacyUseCase getUseCase;

  AboutPrivacyViewModel({
    required this.updateUseCase,
    required this.getUseCase,
  }) : super(AboutPrivacyState()) {
    loadPrivacySettings();
  }

  Future<void> loadPrivacySettings() async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      final PrivacyAboutEntity entity = await getUseCase();

      state = state.copyWith(
        isLoading: false,
        visibility: entity.visibility,
        exceptUids: entity.exceptUids,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'فشل تحميل الإعدادات: ${e.toString()}',
      );
    }
  }

  void setVisibility(String newVisibility) {
    state = state.copyWith(visibility: newVisibility, errorMessage: null, successMessage: null);
  }

  void setExceptUids(List<String> uids) {
    state = state.copyWith(exceptUids: uids, errorMessage: null, successMessage: null);
  }

  Future<void> saveSettings() async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'لا يوجد اتصال بالإنترنت. الرجاء المحاولة لاحقاً.',
      );
      return;
    }

    try {
      final model = PrivacyAboutModel(
        visibility: state.visibility,
        exceptUids: state.visibility == 'contacts_except' ? state.exceptUids : [],
      );

      await updateUseCase(model);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'تم تحديث الخصوصية بنجاح',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'فشل تحديث الخصوصية: ${e.toString()}',
      );
    }
  }
}
