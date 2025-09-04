import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/user_repository.dart';
import '../../../domain/repositories/interface_user_repository.dart';
import '../datesorce/datasorce_provider.dart';

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final dataSource = ref.read(userRemoteDataSourceProvider);
  return UserRepository(remoteDataSource: dataSource);
});