  import 'package:cloud_firestore/cloud_firestore.dart';

  import '../../../model/privacy/last seen and online/last_seen_online_model.dart';

  abstract class LastSeenAndOnlineRemoteDataSource {
    Future<void> setLastSeenAndOnlineSettings(LastSeenAndOnlineModel model, String userId);
    Future<LastSeenAndOnlineModel> getLastSeenAndOnlineSettings(String userId);
  }


  class LastSeenAndOnlineRemoteDataSourceImpl implements LastSeenAndOnlineRemoteDataSource {
    final FirebaseFirestore firestore;

    LastSeenAndOnlineRemoteDataSourceImpl({required this.firestore});

    @override
    Future<void> setLastSeenAndOnlineSettings(LastSeenAndOnlineModel model, String userId) async {
      await firestore.collection('users').doc(userId).set({
        'privacy': {
          'lastSeen_And_Online': {
            'lastSeenVisibility': model.lastSeenVisibility,
            'lastSeenExceptUids': model.lastSeenExceptUids,
            'onlineVisibility': model.onlineVisibility,
          }
        }
      }, SetOptions(merge: true));
    }

    @override
    Future<LastSeenAndOnlineModel> getLastSeenAndOnlineSettings(String userId) async {
      final snapshot = await firestore.collection('users').doc(userId).get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        final privacy = data['privacy'] ?? {};
        final lastSeenData = privacy['lastSeen_And_Online'] ?? {};

        return LastSeenAndOnlineModel(
          lastSeenVisibility: lastSeenData['lastSeenVisibility'] ?? 'everyone',
          lastSeenExceptUids: List<String>.from(lastSeenData['lastSeenExceptUids'] ?? []),
          onlineVisibility: lastSeenData['onlineVisibility'] ?? 'everyone',
        );
      } else {
        return const LastSeenAndOnlineModel(
          lastSeenVisibility: 'everyone',
          lastSeenExceptUids: [],
          onlineVisibility: 'everyone',
        );
      }
    }
  }
