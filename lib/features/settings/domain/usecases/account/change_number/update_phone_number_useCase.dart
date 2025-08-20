import 'package:firebase_auth/firebase_auth.dart';
import '../../../repository/account/change phone/change_number_repository.dart';

class UpdatePhoneNumberUseCase {
  final ChangePhoneNumberRepository repository;

  UpdatePhoneNumberUseCase(this.repository);

  Future<void> call(PhoneAuthCredential credential) {
    return repository.updatePhoneNumber(credential);
  }
}
