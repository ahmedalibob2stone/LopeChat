

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../user/domain/entities/user_entity.dart';
import '../../../../viewmodel/acount/account manage/account_manage_viewmodel.dart';
import '../usecase/provider.dart';

final accountManagerViewModelProvider = StateNotifierProvider<AccountManagerViewModel, AsyncValue<List<UserEntity>>>(
      (ref) {
    final saveNewAccount = ref.watch(saveNewAccountUseCaseProvider);
    final getAllAccounts = ref.watch(getAllAccountsUseCaseProvider);
    final switchToAccount = ref.watch(switchToAccountUseCaseProvider);
  //  final deleteAccount = ref.watch(deleteAccountUseCaseProvider);
    final getCurrentAccount = ref.watch(getCurrentAccountUseCaseProvider);

    return AccountManagerViewModel(
      saveNewAccount: saveNewAccount,
      getAllAccounts: getAllAccounts,
      switchToAccount: switchToAccount,
    //  deleteAccount: deleteAccount,
      getCurrentAccount: getCurrentAccount,
    );
  },
);
