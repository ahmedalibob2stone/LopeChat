import '../entities/status_entity.dart';
import 'dart:io';
import 'package:flutter/material.dart';

abstract class IStatusRepository {
  Future<void> uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,

    required String statusMessage,
    required Map<String, List<String>> seenBy,
    required String uid,

  });

  Stream<List<StatusEntity>> getStatusStream();
  Future<void> markStatusAsSeen({
    required String statusId,
    required String imageUrl,
    required String currentUserUid,
  });
  Future<bool> deleteStatusPhoto(String statusId, int index, List<String> photoUrls);
}