import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../data/datasource/block/block_user_remote_datasorce.dart';
import '../../../../data/datasource/block/block_user_remote_datasorce_impl.dart';
import '../../../../data/repository/block/block_user_repository_impl.dart';
import '../../../../domain/repository/block/block_user_repository.dart';
import '../../../../domain/usecase/blocking/get_blocked_users_usecase.dart';


final blockDataSourceProvider = Provider<BlockDataSource>((ref) {
  return BlockDataSourceImpl(FirebaseFirestore.instance);
});

// مزود الـ Repository
final blockUserRepositoryProvider = Provider<BlockUserRepository>((ref) {
  final dataSource = ref.read(blockDataSourceProvider);
  return BlockUserRepositoryImpl(dataSource);
});

// مزود الـ UseCase
final getBlockedUsersUseCaseProvider = Provider<GetBlockedUsersUseCase>((ref) {
  final repo = ref.read(blockUserRepositoryProvider);
  final auth = FirebaseAuth.instance;
  return GetBlockedUsersUseCase(
    blockRepository: repo,
    auth: auth,
  );
});
