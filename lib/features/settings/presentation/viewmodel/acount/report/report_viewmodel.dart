import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/account/report/report_settings_entity.dart';
import '../../../../domain/usecases/account/report/get_report_settings_usecase.dart';
import '../../../../domain/usecases/account/report/set_report_settings_usecase.dart';
import '../../../../domain/usecases/account/report/update_auto_account_report_usecase.dart';
import '../../../../domain/usecases/account/report/update_auto_channel_report_usecase.dart';

class ReportSettingsState {
  final bool isLoading;
  final ReportSettingsEntity? settings;
  final String? error;

  ReportSettingsState({
    this.isLoading = false,
    this.settings,
    this.error,
  });

  ReportSettingsState copyWith({
    bool? isLoading,
    ReportSettingsEntity? settings,
    String? error,
  }) {
    return ReportSettingsState(
      isLoading: isLoading ?? this.isLoading,
      settings: settings ?? this.settings,
      error: error,
    );
  }
}

class ReportSettingsViewModel extends StateNotifier<ReportSettingsState> {
  final GetReportSettingsUseCase _getReportSettingsUseCase;
  final SetReportSettingsUseCase _setReportSettingsUseCase;
  final UpdateAutoAccountReportUseCase _updateAccountReportUseCase;
  final UpdateAutoChannelReportUseCase _updateChannelReportUseCase;

  ReportSettingsViewModel(
      this._getReportSettingsUseCase,
      this._setReportSettingsUseCase,
      this._updateAccountReportUseCase,
      this._updateChannelReportUseCase,
      ) : super(ReportSettingsState()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final settings = await _getReportSettingsUseCase();
      state = state.copyWith(isLoading: false, settings:  settings);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> setReportSettings({
    required bool autoAccountReportEnabled,
    required bool autoChannelReportEnabled,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final newSettings = ReportSettingsEntity(
        autoAccountReportEnabled: autoAccountReportEnabled,
        autoChannelReportEnabled: autoChannelReportEnabled,
      );
      await _setReportSettingsUseCase(newSettings);
      state = state.copyWith(isLoading: false, settings: newSettings);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateAutoAccountReport(bool value) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _updateAccountReportUseCase(value);
      final updatedSettings = state.settings?.copyWith(autoAccountReportEnabled: value);
      state = state.copyWith(isLoading: false, settings: updatedSettings);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateAutoChannelReport(bool value) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _updateChannelReportUseCase(value);
      final updatedSettings = state.settings?.copyWith(autoChannelReportEnabled: value);
      state = state.copyWith(isLoading: false, settings: updatedSettings);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
