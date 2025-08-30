




import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/repository/account/account manage/auth_local_repository_impl.dart';
import '../../../../../data/repository/account/delet account/delete_account_repository_impl.dart';
import '../../../../../domain/usecases/account/delet account/delete_account_usecase.dart';
import '../../account manage/data/provider.dart';
import '../data/provider.dart';

final deleteAccountUserUseCaseProvider = Provider<DeleteAccountUseCase>((ref) {
  final remoteDataSource = ref.watch(deleteAccountRemoteDataSourceProvider);
  final LocalAuthDataSource = ref.watch(localAuthDataSourceProvider);
  final repository = DeleteAccountRepositoryImpl(remoteDataSource);
  final _repository =AuthLocalRepositoryImpl(LocalAuthDataSource);
  return DeleteAccountUseCase(repository,_repository);
});
