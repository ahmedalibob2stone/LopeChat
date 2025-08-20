import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/status_repository.dart';
import '../datasources/status_remote_data_source.dart';
import 'dart:io';
import '../../domain/entities/status_entity.dart';
final statusRepositoryImplProvider = Provider<IStatusRepository>((ref) {
  final remoteDataSource = ref.read(statusRemoteDataSourceProvider);
  return StatusRepositoryImpl(remoteDataSource); // ✅ هذا هو الـ repository
});

class StatusRepositoryImpl implements IStatusRepository {
  final StatusRemoteDataSource remoteDataSource;

  StatusRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,

    required String statusMessage,
  }) {
    return remoteDataSource.uploadStatus(
      username: username,
      profilePic: profilePic,
      phoneNumber: phoneNumber,
      statusImage: statusImage,

      statusMessage: statusMessage,
    );
  }

  @override
  Future<List<StatusEntity>> getStatuses() {
    return remoteDataSource.getStatus();
  }



  @override
  Future<bool> deleteStatus(int index, List<String> photoUrls) {
    return remoteDataSource.deleteStatus(index, photoUrls);
  }
}
