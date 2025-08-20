

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../user/domain/entities/user_entity.dart';
import '../../domain/usecase/get_all_contacts.dart';








class SelectContactController extends StateNotifier<AsyncValue<List<List<UserEntity>>>> {
  final GetAllContactUseCase getAllContactUseCase;

  SelectContactController({
    required this.getAllContactUseCase,
  }) : super(const AsyncValue.loading()) {
    _selectContact();
  }

  void refreshContacts() async {
    state = await AsyncValue.guard(() async {
      return await getAllContactUseCase();
    });
  }

  void _selectContact() async {
    state = await AsyncValue.guard(() async {
      return await getAllContactUseCase();
    });
  }
}





