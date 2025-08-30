import 'dart:io';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecase/create_group_usecase.dart';

enum GroupStatus {
  initial,
  loading,
  success,
  error,
}

class GroupState {
  final GroupStatus status;
  final String? message;

  const GroupState({
    required this.status,
    this.message,
  });

  factory GroupState.initial() => const GroupState(status: GroupStatus.initial);
  factory GroupState.loading() => const GroupState(status: GroupStatus.loading);
  factory GroupState.success(String message) =>
      GroupState(status: GroupStatus.success, message: message);
  factory GroupState.error(String message) =>
      GroupState(status: GroupStatus.error, message: message);

  bool get isLoading => status == GroupStatus.loading;
}

class CreateGroupController extends StateNotifier<GroupState> {
  final CreateGroupUseCase createGroupUseCase;

  CreateGroupController({required this.createGroupUseCase})
      : super(GroupState.initial());

  Future<void> createGroup(
      String name,
      File profile,
      List<Contact> selectedContacts,
      ) async {
    state = GroupState.loading();
    try {
      await createGroupUseCase.execute(
        name: name,
        profile: profile,
        selectedContacts: selectedContacts,
      );
      state = GroupState.success('تم إنشاء المجموعة بنجاح');
    } catch (e) {
      state = GroupState.error('حدث خطأ: ${e.toString()}');
    }
  }
}
