import 'dart:io';

import '../repository/group_repository.dart';



class UpdateGroupInfoUseCase {
  final IGroupRepository repository;

  UpdateGroupInfoUseCase(this.repository);

  Future<void> execute({
    required String groupId,
    String? newName,
    File? newProfileImage,
  }) {
    return repository.updateGroupNameAndImage(
      groupId: groupId,
      newName: newName,
      newProfileImage: newProfileImage,
    );
  }
}
