import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/datasource/account/change phone/change_phone_number_remote_datasource.dart';
import '../../../../../data/repository/account/change phone/change_number_repository_impl.dart';
import '../../../../../domain/repository/account/change phone/change_number_repository.dart';

final changeNumberRepositoryProvider = Provider<ChangePhoneNumberRepository>((ref) {
  final remoteDataSource = ref.watch(changeNumberRemoteDataSourceProvider);
  return ChangePhoneNumberRepositoryImpl(remoteDataSource: remoteDataSource);
});
final changeNumberRemoteDataSourceProvider = Provider<ChangePhoneNumberRemoteDataSource>((ref) {
  return ChangePhoneNumberRemoteDataSource(firebaseAuth: FirebaseAuth.instance);
});
