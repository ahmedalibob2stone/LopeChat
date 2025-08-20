import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../data/datasorce/chat_group_remote_datasource.dart';
import '../../../../data/repository/chat_group_repository_impl.dart';
import '../../../../domain/repository/chat_group_repository.dart';


final chatGroupRemoteDatasourceProvider = Provider<ChatGroupRemoteDataSource>((ref) {
  return ChatGroupRemoteDataSource(
    fire: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

final chatGroupRepositoryProvider = Provider<ChatGroupRepository>((ref) {
  final remoteDataSource = ref.watch(chatGroupRemoteDatasourceProvider);
  return ChatGroupRepositoryImpl(remoteDataSource: remoteDataSource);
});
