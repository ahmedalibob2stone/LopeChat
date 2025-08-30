import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../domain/usecases/privacy/links/get_links_privacy_usecase.dart';
import '../../../../../domain/usecases/privacy/links/update_links_privacy_usecase.dart';
import '../data/provider.dart';



final getLinksPrivacyUseCaseProvider = Provider<GetLinksPrivacyUseCase>((ref) {
  final repository = ref.watch(linksPrivacyRepositoryProvider);
  final auth = FirebaseAuth.instance;
  return GetLinksPrivacyUseCase(repository: repository, auth: auth);
});

final updateLinksPrivacyUseCaseProvider = Provider<UpdateLinksPrivacyUseCase>((ref) {
  final repository = ref.watch(linksPrivacyRepositoryProvider);
  final auth = FirebaseAuth.instance;
  return UpdateLinksPrivacyUseCase(repository: repository, auth: auth);
});
