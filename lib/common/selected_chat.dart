class SelectedChat {
  final String id;
  final bool isGroup;

  SelectedChat({required this.id, required this.isGroup});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SelectedChat &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              isGroup == other.isGroup;

  @override
  int get hashCode => id.hashCode ^ isGroup.hashCode;
}
