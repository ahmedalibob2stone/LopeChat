import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../../domain/usecases/account/account mange/delete_account_usecase.dart';
import '../../../../../domain/usecases/account/account mange/get_all_accounts_usecase.dart';
import '../../../../../domain/usecases/account/account mange/get_current_account_usecase.dart';
import '../../../../../domain/usecases/account/account mange/save_new_account_usecase.dart';
import '../../../../../domain/usecases/account/account mange/switch_to_account_usecase.dart';
import '../../../../../domain/usecases/account/delet account/delete_account_usecase.dart';
import '../data/provider.dart';




// UseCases
final saveNewAccountUseCaseProvider = Provider<SaveNewAccountUseCase>((ref) {
  return SaveNewAccountUseCase(ref.watch(authLocalRepositoryProvider));
});

final getCurrentAccountUseCaseProvider = Provider<GetCurrentAccountUseCase>((ref) {
  return GetCurrentAccountUseCase(ref.watch(authLocalRepositoryProvider));
});

final getAllAccountsUseCaseProvider = Provider<GetAllAccountsUseCase>((ref) {
  return GetAllAccountsUseCase(ref.watch(authLocalRepositoryProvider));
});

final switchToAccountUseCaseProvider = Provider<SwitchToAccountUseCase>((ref) {
  return SwitchToAccountUseCase(ref.watch(authLocalRepositoryProvider));
});

//final deleteAccountUseCaseProvider = Provider<DeleteAccountUseCase>((ref) {
  //return DeleteAccountUseCase(ref.watch(authLocalRepositoryProvider));
//});
