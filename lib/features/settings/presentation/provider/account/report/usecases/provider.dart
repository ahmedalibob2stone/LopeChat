      import 'package:flutter_riverpod/flutter_riverpod.dart';

      import '../../../../../domain/usecases/account/report/get_report_settings_usecase.dart';
      import '../../../../../domain/usecases/account/report/set_report_settings_usecase.dart';
      import '../../../../../domain/usecases/account/report/update_auto_account_report_usecase.dart';
      import '../../../../../domain/usecases/account/report/update_auto_channel_report_usecase.dart';
      import '../data/provider.dart';


      final getReportSettingsUseCaseProvider = Provider<GetReportSettingsUseCase>((ref) {
        final repository = ref.read(reportSettingsRepositoryProvider);
        return GetReportSettingsUseCase(repository);
      });

      final setReportSettingsUseCaseProvider = Provider<SetReportSettingsUseCase>((ref) {
        final repository = ref.read(reportSettingsRepositoryProvider);
        return SetReportSettingsUseCase(repository);
      });

      final updateAutoAccountReportUseCaseProvider = Provider<UpdateAutoAccountReportUseCase>((ref) {
        final repository = ref.read(reportSettingsRepositoryProvider);
        return UpdateAutoAccountReportUseCase(repository);
      });

      final updateAutoChannelReportUseCaseProvider = Provider<UpdateAutoChannelReportUseCase>((ref) {
        final repository = ref.read(reportSettingsRepositoryProvider);
        return UpdateAutoChannelReportUseCase(repository);
      });
