class LastSeenAndOnlineEntity {
  final String lastSeenVisibility;
  final List<String> lastSeenExceptUids;
  final String onlineVisibility;

  const LastSeenAndOnlineEntity({
    required this.lastSeenVisibility,
    required this.lastSeenExceptUids,
    required this.onlineVisibility,
  });
}
