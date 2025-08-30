import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasource/chat lock/chat_lock_local_datasource.dart';
import '../../../../data/repository/chat lock/chat_lock_repository_impl.dart';
import '../../../../domain/repository/chat lock/chat_lock_repository.dart';

final chatLockLocalDataSourceProvider = Provider<ChatLockLocalDataSource>((ref) {
  return ChatLockLocalDataSource();
});
final chatLockRepositoryProvider = Provider<ChatLockRepository>((ref) {
  final localDataSource = ref.watch(chatLockLocalDataSourceProvider);
  return ChatLockRepositoryImpl(localDataSource: localDataSource);
});
