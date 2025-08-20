class ChatModel {
  final String chatId;
  final List<String> participants; // معرفات المستخدمين في المحادثة
  final bool disappearingMessagesEnabled; // هل الرسائل المختفية مفعلة؟
  final int disappearingMessagesDurationSeconds; // مدة اختفاء الرسائل بالثواني

  ChatModel({
    required this.chatId,
    required this.participants,
    this.disappearingMessagesEnabled = false,
    this.disappearingMessagesDurationSeconds = 0,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      disappearingMessagesEnabled: map['disappearingMessages']?['isEnabled'] ?? false,
      disappearingMessagesDurationSeconds: map['disappearingMessages']?['durationSeconds'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'participants': participants,
      'disappearingMessages': {
        'isEnabled': disappearingMessagesEnabled,
        'durationSeconds': disappearingMessagesDurationSeconds,
      },
    };
  }
}
class DisappearingMessagesConfig {
  final bool isEnabled;
  final int durationSeconds;

  DisappearingMessagesConfig({
    required this.isEnabled,
    required this.durationSeconds,
  });

  factory DisappearingMessagesConfig.fromMap(Map<String, dynamic> map) {
    return DisappearingMessagesConfig(
      isEnabled: map['isEnabled'] ?? false,
      durationSeconds: map['durationSeconds'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isEnabled': isEnabled,
      'durationSeconds': durationSeconds,
    };
  }
}

