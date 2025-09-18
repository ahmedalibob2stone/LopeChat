import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../storsge/repository.dart';
import '../../../../data/datasorce/chat_massage_remote_datasource.dart';
import '../../../../data/repository/chat_message_repository_impl.dart';
import '../../../../domain/repository/chat_message_repository.dart';
final chatRemoteDataSourceProvider = Provider<ChatMessageRemoteDataSource>((ref) {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final storageRepo = ref.read(FirebaseStorageRepositoryProvider);
  return ChatMessageRemoteDataSource(fire: firestore, auth: auth, storage: storageRepo);
});
final chatMessageRepositoryProvider = Provider<IChatMessageRepository>((ref) {
  final remoteDataSource = ref.watch(chatRemoteDataSourceProvider);
  return ChatMessageRepositoryImpl(remoteDataSource: remoteDataSource);
});