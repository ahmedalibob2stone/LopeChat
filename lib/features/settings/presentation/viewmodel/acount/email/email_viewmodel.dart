import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/usecases/account/email/get_email_usecase.dart';
import '../../../../domain/usecases/account/email/set_email_usecase.dart';


enum EmailEditStatus { initial, loading, success, error }

class EmailEditState {
  final EmailEditStatus status;
  final String? email;
  final String? errorMessage;

  EmailEditState({
    this.status = EmailEditStatus.initial,
    this.email,
    this.errorMessage,
  });

  EmailEditState copyWith({
    EmailEditStatus? status,
    String? email,
    String? errorMessage,
  }) {
    return EmailEditState(
      status: status ?? this.status,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class EmailEditViewModel extends StateNotifier<EmailEditState> {
  final GetEmailUseCase _getEmailUseCase;
  final SetEmailUseCase _setEmailUseCase;

  EmailEditViewModel({
    required GetEmailUseCase getEmailUseCase,
    required SetEmailUseCase setEmailUseCase,
  })  : _getEmailUseCase = getEmailUseCase,
        _setEmailUseCase = setEmailUseCase,
        super(EmailEditState()) {
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    state = state.copyWith(status: EmailEditStatus.loading);
    try {
      final email = await _getEmailUseCase();
      state = state.copyWith(
        status: EmailEditStatus.success,
        email: email,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: EmailEditStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> saveEmail(String email) async {
    state = state.copyWith(status: EmailEditStatus.loading);
    try {
      await _setEmailUseCase(email);
      state = state.copyWith(
        status: EmailEditStatus.success,
        email: email,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: EmailEditStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
