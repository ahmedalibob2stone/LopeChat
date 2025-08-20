import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/usecases/privacy/profile/get_curent_user_uid.dart';


final getCurrentUserIdUseCaseProvider = Provider<GetCurrentUserIdUseCase>((ref) {
  return GetCurrentUserIdUseCase(FirebaseAuth.instance);
});
