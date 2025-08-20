import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecase/add_users_usecase.dart';
import '../../domain/usecase/delete_member_usecase.dart';
import '../../domain/usecase/add_admin_usecase.dart';
import '../../domain/usecase/remove_admin_usecase.dart';

class GroupMemberState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const GroupMemberState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  GroupMemberState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return GroupMemberState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class GroupMemberManagerViewModel extends StateNotifier<GroupMemberState> {
  final AddUsersToGroupUseCase addMembersUseCase;
  final DeleteMemberFromGroupUseCase removeMemberUseCase;
  final AddAdminUseCase addAdminUseCase;
  final RemoveAdminUseCase removeAdminUseCase;

  GroupMemberManagerViewModel({
    required this.addMembersUseCase,
    required this.removeMemberUseCase,
    required this.addAdminUseCase,
    required this.removeAdminUseCase,
  }) : super(const GroupMemberState());

  Future<void> addMembers(List<Contact> selectedContacts, String groupId) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      await addMembersUseCase.execute(
        selectedContacts: selectedContacts,
        groupId: groupId,
      );
      state = state.copyWith(isLoading: false, successMessage: 'تمت إضافة الأعضاء بنجاح');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'فشل الإضافة: ${e.toString()}');
    }
  }

  Future<void> removeMember(String groupId, String memberId) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      await removeMemberUseCase.execute(
        groupId: groupId,
        memberId: memberId,
      );
      state = state.copyWith(isLoading: false, successMessage: 'تمت إزالة العضو بنجاح');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'فشل الحذف: ${e.toString()}');
    }
  }

  Future<void> addAdmin(String groupId, String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      await addAdminUseCase.execute(groupId: groupId, adminUid: userId);
      state = state.copyWith(isLoading: false, successMessage: 'تمت إضافة المشرف بنجاح');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'فشل الإضافة: ${e.toString()}');
    }
  }

  Future<void> removeAdmin(String groupId, String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      await removeAdminUseCase.execute(groupId: groupId, adminUid: userId);
      state = state.copyWith(isLoading: false, successMessage: 'تمت إزالة المشرف بنجاح');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'فشل الإزالة: ${e.toString()}');
    }
  }
}
