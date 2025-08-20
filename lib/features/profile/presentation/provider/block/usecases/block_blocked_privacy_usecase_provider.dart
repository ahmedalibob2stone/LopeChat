import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../data/datasource/block/block_user_remote_datasorce.dart';
import '../../../../data/datasource/block/block_user_remote_datasorce_impl.dart';
import '../../../../data/repository/block/block_user_repository_impl.dart';
import '../../../../domain/repository/block/block_user_repository.dart';
import '../../../../domain/usecase/blocking/block_user_usecase.dart';



final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final blockDataSourceProvider = Provider<BlockDataSource>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return BlockDataSourceImpl(firestore);
});

final blockUserRepositoryProvider = Provider<BlockUserRepository>((ref) {
  final dataSource = ref.watch(blockDataSourceProvider);
  return BlockUserRepositoryImpl(dataSource);
});

final uuidProvider = Provider<Uuid>((ref) => const Uuid());

final blockUseUseCaseProvider = Provider<BlockUserUseCase>((ref) {
  final repository = ref.watch(blockUserRepositoryProvider);
  return BlockUserUseCase(repository);
});

