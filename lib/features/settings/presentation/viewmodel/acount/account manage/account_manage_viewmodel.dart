import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../user/domain/entities/user_entity.dart';
import '../../../../domain/usecases/account/account mange/get_all_accounts_usecase.dart';
import '../../../../domain/usecases/account/account mange/get_current_account_usecase.dart';
import '../../../../domain/usecases/account/account mange/save_new_account_usecase.dart';
import '../../../../domain/usecases/account/account mange/switch_to_account_usecase.dart';




class AccountManagerViewModel extends StateNotifier<AsyncValue<List<UserEntity>>> {
final SaveNewAccountUseCase saveNewAccount;
final GetAllAccountsUseCase getAllAccounts;
final SwitchToAccountUseCase switchToAccount;
//final DeleteAccountLocalUseCase deleteAccount;
final GetCurrentAccountUseCase getCurrentAccount;

AccountManagerViewModel({
required this.saveNewAccount,
required this.getAllAccounts,
required this.switchToAccount,
//required this.deleteAccount,
required this.getCurrentAccount,
}) : super(const AsyncValue.loading()) {
loadAccounts();
}

Future<void> loadAccounts() async {
state = const AsyncValue.loading();
try {
final accounts = await getAllAccounts();
state = AsyncValue.data(accounts);
} catch (e, st) {
state = AsyncValue.error(e, st);
}
}

Future<void> addAccount(UserEntity user) async {
try {
  await saveNewAccount(user);

await loadAccounts();
} catch (e, st) {
state = AsyncValue.error(e, st);
}
}

Future<void> switchAccount(String uid) async {
try {
await switchToAccount(uid);
await loadAccounts();
} catch (e, st) {
state = AsyncValue.error(e, st);
}
}

//Future<void> onDeleteAccount(String uid) async {
 // try {
   // await deleteAccount(uid);
 //   await loadAccounts();
  //} catch (e, st) {
  //  state = AsyncValue.error(e, st);
  //}
//}


Future<UserEntity?> getCurrent() async {
try {
return await getCurrentAccount();
} catch (_) {
return null;
}
}
}
