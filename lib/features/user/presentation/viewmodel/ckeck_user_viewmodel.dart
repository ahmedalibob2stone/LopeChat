

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_my_data_stream_usecase.dart';






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
      isSuccess: false,
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
        print("🎯 ViewModel: user from stream = $user");

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
        print("❌ ViewModel Error: $err");
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
