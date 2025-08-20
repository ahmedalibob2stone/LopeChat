
import '../repositories/interface_user_repository.dart';

class UpdateProfileImageUrlUseCase {
  final IUserRepository repository;

  UpdateProfileImageUrlUseCase(this.repository);

  Future<void> call(String photoUrl) {
    return repository.updateProfileImageUrl(photoUrl);
  }
}
