import 'package:firebase_auth/firebase_auth.dart';

import '../../../repository/account/change phone/change_number_repository.dart';

class SignInWithPhoneCredentialUseCase {
final ChangePhoneNumberRepository repository;

SignInWithPhoneCredentialUseCase(this.repository);

Future<UserCredential> call(PhoneAuthCredential credential) {
return repository.signInWithPhoneCredential(credential);
}
}
