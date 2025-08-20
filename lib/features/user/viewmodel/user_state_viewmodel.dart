import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/usecases/provider/setuser_state_Provider.dart';
import '../domain/usecases/set_user_StateUseCase.dart';


class UserStateViewModel extends StateNotifier<AsyncValue<void>> {
  final SetUserStateUseCase setUserStateUseCase;

  UserStateViewModel({required this.setUserStateUseCase})
      : super(const AsyncValue.data(null));

  Future<void> setUserState(String isOnline) async {
    try {
      state = const AsyncValue.loading();
      await setUserStateUseCase(isOnline);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
