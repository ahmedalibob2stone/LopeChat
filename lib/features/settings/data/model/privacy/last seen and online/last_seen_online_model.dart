import '../../../../domain/entities/privacy/last seen and online/last_seen_and_online.dart';

class LastSeenAndOnlineModel extends LastSeenAndOnlineEntity {
  const LastSeenAndOnlineModel({
    required String lastSeenVisibility,
    required List<String> lastSeenExceptUids,
    required String onlineVisibility,
  }) : super(
    lastSeenVisibility: lastSeenVisibility,
    lastSeenExceptUids: lastSeenExceptUids,
    onlineVisibility: onlineVisibility,
  );

  factory LastSeenAndOnlineModel.fromMap(Map<String, dynamic> map) {
    return LastSeenAndOnlineModel(
      lastSeenVisibility: map['lastSeenVisibility'] ?? 'everyone',
      lastSeenExceptUids: List<String>.from(map['lastSeenExceptUids'] ?? []),
      onlineVisibility: map['onlineVisibility'] ?? 'everyone',
    );
  }
  factory LastSeenAndOnlineModel.fromEntity(LastSeenAndOnlineEntity entity) {
    return LastSeenAndOnlineModel(
      lastSeenVisibility: entity.lastSeenVisibility,
      lastSeenExceptUids: entity.lastSeenExceptUids,
      onlineVisibility: entity.onlineVisibility,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lastSeenVisibility': lastSeenVisibility,
      'lastSeenExceptUids': lastSeenExceptUids,
      'onlineVisibility': onlineVisibility,
    };
  }
  LastSeenAndOnlineEntity toEntity() {
    return LastSeenAndOnlineEntity(
      lastSeenVisibility: lastSeenVisibility,
      lastSeenExceptUids: lastSeenExceptUids,
      onlineVisibility: onlineVisibility,
    );
  }
}
