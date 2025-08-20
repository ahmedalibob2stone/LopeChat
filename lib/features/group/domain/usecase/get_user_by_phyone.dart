

import '../repository/group_repository.dart';

class FindUserIdByPhoneUseCase {
  final IGroupRepository repository;

  FindUserIdByPhoneUseCase(this.repository);

  Future<String?> execute( {required String phoneNumber}) {
    return repository.getUserIdByPhone(phoneNumber);
  }
}
