
class LinksPrivacyEntity {
  final String visibility;
  final List<String> exceptUids;

  LinksPrivacyEntity({
    required this.visibility,
    this.exceptUids = const [],
  });
}
