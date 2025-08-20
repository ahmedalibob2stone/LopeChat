import '../repositories/status_repository.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class UploadStatusUseCase {
  final IStatusRepository repository;

  UploadStatusUseCase(this.repository);

  Future<void> call({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required String statusMessage,
  }) {
    return repository.uploadStatus(
      username: username,
      profilePic: profilePic,
      phoneNumber: phoneNumber,
      statusImage: statusImage,
      statusMessage: statusMessage,
    );
  }
}
