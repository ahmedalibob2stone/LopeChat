
  import '../../../entities/privacy/last seen and online/last_seen_and_online.dart';

  abstract class LastSeenAndOnlineRepository {
    Future<void> saveLastSeenAndOnlineSettings(LastSeenAndOnlineEntity entity, String uid);

    Future<LastSeenAndOnlineEntity?> getLastSeenAndOnlineSettings(String uid);
  }
