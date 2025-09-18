  import '../../../user/data/datasources/user_remote_data_source.dart';
  import '../../domain/repository/user_status_repository.dart';
  import '../datasorce/user_status_remote_data_source.dart';

  class UserStatusRepositoryImpl implements UserStatusRepository {
    final UserStatusRemoteDataSource remoteDataSource;

    UserStatusRepositoryImpl({required this.remoteDataSource});

    @override
    Future<void> updateUserStatus({required bool isOnline}) {
      return remoteDataSource.updateUserStatus(isOnline: isOnline);
    }

    @override
    Future<String> getUserLastSeen(String userId) {
      return remoteDataSource.getUserLastSeen(userId);
    }

    @override
    Future<String> getUserOnlineStatus(String userId) {
      return remoteDataSource.getUserOnlineStatus(userId);
    }
  }
