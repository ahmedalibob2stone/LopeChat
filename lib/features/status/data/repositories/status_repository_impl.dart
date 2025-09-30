import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/status_repository.dart';
import '../datasources/status_remote_data_source.dart';
import 'dart:io';
import '../../domain/entities/status_entity.dart';

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
    required Map<String, List<String>> seenBy,
    required String uid,

  }) {
    return remoteDataSource.uploadStatus(
      username: username,
      profilePic: profilePic,
      phoneNumber: phoneNumber,
      statusImage: statusImage,
   uid: uid,
      statusMessage: statusMessage, seenBy: {},
    );
  }

  @override
  Stream<List<StatusEntity>> getStatusStream() {
    return remoteDataSource.getStatusStream();
  }

  Future<void> markStatusAsSeen({
    required String statusId,
    required String imageUrl,
    required String currentUserUid,
  }) async {
    await remoteDataSource.markStatusAsSeen(
      statusId: statusId,
      imageUrl: imageUrl,
      currentUserUid: currentUserUid,
    );
  }
  @override
  Future<bool> deleteStatusPhoto(String statusId, int index, List<String> photoUrls) {
    return remoteDataSource.deleteStatusPhoto(statusId,index, photoUrls);
  }
}
