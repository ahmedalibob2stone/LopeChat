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
  });

  Future<List<StatusEntity>> getStatuses();


  Future<bool> deleteStatus(int index, List<String> photoUrls);
}