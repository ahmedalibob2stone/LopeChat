import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/create_group_viewmodel.dart';
import '../../viewmodel/delete_group_viewmodel.dart';
import '../../viewmodel/get_group_data_viewmodel.dart';
import '../../viewmodel/group_information_viewmodel.dart';
import '../../viewmodel/leave_group_viewmodel.dart';
import '../../viewmodel/mange_members_viewmodel.dart';
import '../../viewmodel/update_group_info_viewmodel.dart';
import '../usecase/provider.dart';

final CreateGroupViewModelProvider =
StateNotifierProvider<CreateGroupController, GroupState>((ref) {
  final useCase = ref.read(createGroupUseCaseProvider);
  return CreateGroupController(createGroupUseCase: useCase);
});


final groupInformationViewModelProvider = StateNotifierProvider.family<GroupInformationViewModel, GroupInformationState, String>(
      (ref, groupId) {
    final useCase = ref.watch(getGroupInfoUseCaseProvider);
    final viewModel = GroupInformationViewModel(getGroupInfoUseCase: useCase);
    viewModel.loadGroupInfo(groupId);
    return viewModel;
  },
);

final deleteGroupViewModelProvider =
StateNotifierProvider<DeleteGroupViewModel, AsyncValue<void>>((ref) {
  final useCase = ref.watch(deleteGroupUseCaseProvider);
  return DeleteGroupViewModel(useCase);
});




final groupProfileViewModelProvider = StateNotifierProvider<GroupMemberManagerViewModel, GroupMemberState>((ref) {
  final addUseCase = ref.watch(addUsersUseCaseProvider);
  final deleteUseCase = ref.watch(deleteMemberUseCaseProvider);
  final addAdminUseCase=ref.watch(addAdminUseCaseProvider);
  final  removeAdminUseCase=ref.watch(removeAdminUseCaseProvider);
//  final getAdminUseCase = ref.watch(getAdminUidUseCaseProvider);

  return GroupMemberManagerViewModel(
    addMembersUseCase:addUseCase, removeMemberUseCase: deleteUseCase,
    addAdminUseCase:addAdminUseCase, removeAdminUseCase: removeAdminUseCase,
//    getAdminUidUseCase: getAdminUseCase,

  );

});


final leaveGroupViewModelProvider =
StateNotifierProvider<LeaveGroupViewModel, bool>((ref) {
  final useCase = ref.watch(leaveGroupUseCaseProvider);
  return LeaveGroupViewModel(useCase);
});


final updateGroupInfoViewModelProvider = StateNotifierProvider<UpdateGroupInfoViewModel, UpdateGroupInfoState>((ref) {
  final useCase = ref.watch(updateGroupInfoUseCaseProvider);
  return UpdateGroupInfoViewModel(updateGroupInfoUseCase: useCase);
});
final groupInfoViewModelProvider =
StateNotifierProvider<GroupInfoViewModel, GroupInfoState>((ref) {
  final getGroupDataUseCase = ref.watch(getGroupDataUseCaseProvider);
  return GroupInfoViewModel(getGroupDataUseCase: getGroupDataUseCase);
});
