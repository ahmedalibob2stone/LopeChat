import 'dart:io';
import '../repositories/interface_user_repository.dart';

class SaveUserDataToFirebaseUseCase {
  final IUserRepository repository;

  SaveUserDataToFirebaseUseCase(this.repository);

  Future<void> call({
    required String name,
    required File? profile,
    required String statu,
  }) {
    return repository.saveUserDatetoFirebase(
      name: name,
      profile: profile,
      statu: statu,
    );
  }
}
