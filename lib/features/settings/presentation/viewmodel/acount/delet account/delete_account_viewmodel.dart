import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/usecases/account/delet account/delete_account_usecase.dart';


class DeleteState {
  final bool isLoading;
  final bool isDeleted;
  final String? errorMessage;

  DeleteState({
    this.isLoading = false,
    this.isDeleted = false,
    this.errorMessage,
  });

  DeleteState copyWith({
    bool? isLoading,
    bool? isDeleted,
    String? errorMessage,
  }) {
    return DeleteState(
      isLoading: isLoading ?? this.isLoading,
      isDeleted: isDeleted ?? this.isDeleted,
      errorMessage: errorMessage,
    );
  }
}

class DeleteAccountViewModel extends StateNotifier<DeleteState> {
  final DeleteAccountUseCase _deleteAccountUseCase;


  DeleteAccountViewModel(this._deleteAccountUseCase) : super(DeleteState());

  Future<void> deleteAccount(String uid) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isDeleted: false);

    try {
      await _deleteAccountUseCase.execute(uid);
      state = state.copyWith(isLoading: false, isDeleted: true, errorMessage: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, isDeleted: false, errorMessage: e.toString());
    }
  }

}
