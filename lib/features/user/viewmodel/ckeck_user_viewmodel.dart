

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/user_entity.dart';
import '../domain/usecases/get_myDataStream_UseCase.dart';
import 'dart:async';






class CheckUserState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final UserEntity? user;

  const CheckUserState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
    this.user,
  });

  factory CheckUserState.initial() {
    return const CheckUserState(
      isLoading: true,
      isSuccess: false, // البداية false لأننا لم نجلب البيانات بعد
      errorMessage: null,
      user: null,
    );
  }

  CheckUserState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    UserEntity? user,
  }) {
    return CheckUserState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}


class CheckUserViewModel extends StateNotifier<CheckUserState> {
  final GetMyDataStreamUseCase _getMyDataStreamUseCase;
  StreamSubscription<UserEntity?>? _subscription;

  CheckUserViewModel(this._getMyDataStreamUseCase)
      : super(CheckUserState.initial()) {
    getMyData();
  }

  void getMyData() {
    state = state.copyWith(isLoading: true, errorMessage: null);

    _subscription?.cancel();
    _subscription = _getMyDataStreamUseCase().listen(
          (user) {
        if (user == null) {
          state = state.copyWith(
            isLoading: false,
            isSuccess: false,
            user: null,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            isSuccess: true,
            user: user,
          );
        }
      },
      onError: (err) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: err.toString(),
        );
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
