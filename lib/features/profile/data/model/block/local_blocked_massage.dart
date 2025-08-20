import 'dart:io';
import '../../../../../../common/enums/enum_massage.dart';

class LocalBlockedMessage {
  final String messageId;
  final String chatId;
  final String text;
  final String? filePath;
  final String? gifUrl;
  final EnumData type;
  final String senderId;
  final DateTime time;
  final String? repliedMessage;
  final String? repliedMessageType;
  final bool isLocalBlocked;

  LocalBlockedMessage({
    required this.messageId,
    required this.chatId,
    required this.text,
    this.filePath,
    this.gifUrl,
    required this.type,
    required this.senderId,
    required this.time,
    this.repliedMessage,
    this.repliedMessageType,
    this.isLocalBlocked = true,
  });
}
