import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasorce/chat_contact_remote_datasource.dart';
import '../../../../data/repository/chat_contct_repository_impl.dart';
import '../../../../domain/repository/chat_contact_repository.dart';

final ChatContactRemoteDataSourceProvider = Provider<ChatContactRemoteDataSource>((ref) {
  return ChatContactRemoteDataSource(
    fire: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref
  );
});

final ChatContactRepositoryProvider = Provider<ChatContactRepository>((ref) {
  final remoteDataSource = ref.watch(ChatContactRemoteDataSourceProvider);
  return ChatContactRepositoryImpl(remoteDataSource: remoteDataSource);
});
