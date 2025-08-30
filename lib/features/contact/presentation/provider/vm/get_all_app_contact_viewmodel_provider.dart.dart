import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../user/domain/entities/user_entity.dart';
import '../../viewmodel/select_contact_controller.dart';
import '../usecases/get_all_contacts_usecases_provider.dart';

final selectContactControllerProvider = Provider<SelectContactController>((ref) {
  final useCase = ref.watch(getAllContactUseCaseProvider);
  return SelectContactController(getAllContactUseCase: useCase);
});

final contactsControllerProvider = StateNotifierProvider<SelectContactController,
    AsyncValue<List<List<UserEntity>>>>((ref) {
  final useCase = ref.watch(getAllContactUseCaseProvider);
  return SelectContactController(getAllContactUseCase: useCase);
});