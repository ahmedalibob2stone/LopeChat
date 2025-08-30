
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../viewmodel/acount/delet account/delete_account_viewmodel.dart';
import '../usecases/provider.dart';

final deleteAccountViewModelProvider = StateNotifierProvider<DeleteAccountViewModel,
    DeleteState>((ref) {
  final useCase = ref.read(deleteAccountUserUseCaseProvider);
  return DeleteAccountViewModel(useCase);
});
