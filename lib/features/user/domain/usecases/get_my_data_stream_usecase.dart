import 'package:firebase_auth/firebase_auth.dart';
import '../entities/user_entity.dart';
import '../repositories/interface_user_repository.dart';

class GetMyDataStreamUseCase {
  final IUserRepository repository;

  GetMyDataStreamUseCase(this.repository);

  Stream<UserEntity?> call() {
    return repository.myData();

  }
}


