
import 'dart:io';
import '../repositories/interface_user_repository.dart';

class UploadProfileImageUseCase {
  final IUserRepository repository;

  UploadProfileImageUseCase(this.repository);

  Future<String> call(File file) {
    return repository.uploadProfileImage(file);
  }
}
