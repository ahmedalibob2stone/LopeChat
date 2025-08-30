import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../data/datasource/privacy/last seen and online/last_seen_and_online_privacy_local_datasorce.dart';
import '../../../../../data/datasource/privacy/last seen and online/last_seen_and_online_privacy_remote_datasource.dart';
import '../../../../../data/repository/privacy/last seen and online/last_seen_and_online_repository_impl.dart';
import '../../../../../domain/repository/privacy/last seen and online/privacy_repository.dart';
import '../../../../../domain/usecases/privacy/last seen and online/get_last_seen_and_online_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';


final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final remoteDataSourceProvider = Provider<LastSeenAndOnlineRemoteDataSource>((ref) {
  return LastSeenAndOnlineRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
  );
});

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final localDataSourceProvider = Provider<LastSeenAndOnlineLocalDataSource>((ref) {
  final sharedPrefsAsync = ref.watch(sharedPreferencesProvider);

  return sharedPrefsAsync.when(
    data: (sharedPrefs) {
      return LastSeenAndOnlineLocalDataSourceImpl(sharedPreferences: sharedPrefs);
    },
    loading: () {
      throw UnimplementedError('SharedPreferences not loaded yet');
    },
    error: (err, stack) {
      throw Exception('Failed to load SharedPreferences: $err');
    },
  );
});

final lastSeenAndOnlineRepositoryProvider = Provider<LastSeenAndOnlineRepository>((ref) {
  return LastSeenAndOnlineRepositoryImpl(
    remoteDataSource: ref.read(remoteDataSourceProvider),
    localDataSource: ref.read(localDataSourceProvider),
  );
});

final getLastSeenAndOnlineUseCaseProvider = Provider<GetLastSeenAndOnlineUseCase>((ref) {
  return GetLastSeenAndOnlineUseCase(
    repository: ref.read(lastSeenAndOnlineRepositoryProvider),
    auth: ref.read(firebaseAuthProvider),
  );
});


