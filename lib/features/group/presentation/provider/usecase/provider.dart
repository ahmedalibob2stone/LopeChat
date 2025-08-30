import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecase/add_admin_usecase.dart';
import '../../../domain/usecase/add_users_usecase.dart';
import '../../../domain/usecase/create_group_usecase.dart';
import '../../../domain/usecase/delete_group_usecase.dart';
import '../../../domain/usecase/delete_member_usecase.dart';
import '../../../domain/usecase/get_admin_uid_usecase.dart';
import '../../../domain/usecase/get_group_Info_usecase.dart';

import '../../../domain/usecase/get_group_data_usecase.dart';
import '../../../domain/usecase/get_user_by_phyone.dart';
import '../../../domain/usecase/leave_group_usecase.dart';
import '../../../domain/usecase/remove_admin_usecase.dart';
import '../../../domain/usecase/update_group_info_usecase.dart';
import '../datasorce/provider.dart';

final getGroupInfoUseCaseProvider = Provider<GetGroupInfoUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return GetGroupInfoUseCase(repository);
});

final deleteGroupUseCaseProvider = Provider<DeleteGroupUseCase>((ref) {
  final repo = ref.watch(groupRepositoryProvider);
  return DeleteGroupUseCase(repo);
});

final createGroupUseCaseProvider = Provider<CreateGroupUseCase>((ref) {
  final repository = ref.read(groupRepositoryProvider);
  return CreateGroupUseCase(repository);
});




// Get Admin UID UseCase
final getAdminUidUseCaseProvider = Provider<GetAdminUidUseCase>((ref) {
  final repo = ref.watch(groupRepositoryProvider);
  return GetAdminUidUseCase(repo);
});
final groupAdminUidProvider = FutureProvider.family<String, String>((ref, groupId) {
  final getAdminUidUseCase = ref.watch(getAdminUidUseCaseProvider);
  return getAdminUidUseCase.execute(groupId);
});

final addUsersUseCaseProvider = Provider<AddUsersToGroupUseCase>((ref) {
  final repository = ref.read(groupRepositoryProvider);
  return AddUsersToGroupUseCase(repository);
});

final deleteMemberUseCaseProvider = Provider<DeleteMemberFromGroupUseCase>((ref) {
  final repository = ref.read(groupRepositoryProvider);
  return DeleteMemberFromGroupUseCase(repository);
});



final findUserIdByPhoneUseCaseProvider = Provider<FindUserIdByPhoneUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return FindUserIdByPhoneUseCase(repository);
});
final findUserIdByPhoneProvider = FutureProvider.family<String?, String>((ref, phoneNumber) {
  final useCase = ref.watch(findUserIdByPhoneUseCaseProvider);
  return useCase.execute(phoneNumber: phoneNumber);
});
final addAdminUseCaseProvider = Provider<AddAdminUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return AddAdminUseCase(repository);
});

final removeAdminUseCaseProvider = Provider<RemoveAdminUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return RemoveAdminUseCase(repository);
});


final leaveGroupUseCaseProvider = Provider<LeaveGroupUseCase>((ref) {
  final repo = ref.watch(groupRepositoryProvider);
  return LeaveGroupUseCase(repo);
});
final updateGroupInfoUseCaseProvider = Provider<UpdateGroupInfoUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return UpdateGroupInfoUseCase(repository);
});

final getGroupDataUseCaseProvider = Provider<GetGroupDataUseCase>((ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return GetGroupDataUseCase(repository);
});
