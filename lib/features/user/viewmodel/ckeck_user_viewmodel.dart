

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/user_entity.dart';
import '../domain/usecases/get_myDataStream_UseCase.dart';
import '../domain/usecases/provider/get_my_DataStream_provider.dart';





class CheckUserState {
  final bool isLoading;
  final bool  isSuccess;
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
      isSuccess: true,
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

  CheckUserViewModel(this._getMyDataStreamUseCase)
      : super(CheckUserState.initial()) {
    getMyData();
  }

  void getMyData() {
    state = state.copyWith(isLoading: true, errorMessage: null);

    _getMyDataStreamUseCase().listen((user) {
      if (user == null) {
        state = state.copyWith(isSuccess: false, user: null, isLoading: false);
      } else {
        state = state.copyWith(isSuccess: true, user: user, isLoading: false);
      }
    });
  }
}
