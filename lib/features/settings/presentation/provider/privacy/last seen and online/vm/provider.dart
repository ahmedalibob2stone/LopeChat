import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/privacy/last seen and online/last_seen_and_online.dart';
import '../../../../../domain/usecases/privacy/last seen and online/get_last_seen_and_online_usecase.dart';
import '../../../../../domain/usecases/privacy/last seen and online/update_last_seen_and_online_usecase.dart';
import '../../../../viewmodel/privacy/last seen and online/privacy_settings_viewmodel.dart';
import '../usecase/get_last_seen_and_online_usecase_provider.dart';

final getLastSeenAndOnlineUseCaseProvider = Provider<GetLastSeenAndOnlineUseCase>((ref) {
  throw UnimplementedError();
});

final updateLastSeenAndOnlineUseCaseProvider = Provider<UpdateLastSeenAndOnlineUseCase>((ref) {
  throw UnimplementedError();
});

final lastSeenAndOnlineViewModelProvider =
StateNotifierProvider<LastSeenAndOnlineViewModel, LastSeenAndOnlineState>(
      (ref) {
    final getUseCase = ref.watch(getLastSeenAndOnlineUseCaseProvider);
    final updateUseCase = ref.watch(updateLastSeenAndOnlineUseCaseProvider);

    return LastSeenAndOnlineViewModel(
      getUseCase: getUseCase,
      updateUseCase: updateUseCase,
    );
  },
);
final lastSeenAndOnlineViewModelProvidering = StateNotifierProvider.family<LastSeenAndOnlineViewModel, LastSeenAndOnlineState, String>((ref, uid) {
  return LastSeenAndOnlineViewModel(
    getUseCase: ref.watch(getLastSeenAndOnlineUseCaseProvider),
    updateUseCase: ref.watch(updateLastSeenAndOnlineUseCaseProvider),
  )..loadDataForUser(uid, []); // تمرر قائمة جهات الاتصال الحقيقية
});

