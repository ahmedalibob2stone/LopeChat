import 'dart:io';
import '../repositories/interface_user_repository.dart';

class UpdateProfileImageUseCase {
  final IUserRepository repository;

  UpdateProfileImageUseCase(this.repository);

  Future<void> call(File file) {
    return repository.updateUserProfilePicture(file);
  }
}
