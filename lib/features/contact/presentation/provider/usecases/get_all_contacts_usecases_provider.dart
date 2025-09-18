import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecase/get_all_contacts.dart';
import '../datasorce/get_all_contacts_datasorce_provider.dart';

final getAllContactsUseCaseProvider = Provider<GetAllContactsUseCase>((ref) {
  // هنا أرجع الـ UseCase الخاص بك
  final repository = ref.read(contactRepositoryProvider); // مثال: provider للـ repository
  return GetAllContactsUseCase(repository);
});
