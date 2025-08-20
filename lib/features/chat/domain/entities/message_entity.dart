import 'package:lopechat/common/enums/enum_massage.dart';

class MessageEntity {
  final String senderId;
  final String chatId;
  final String text;
  final EnumData type;
  final DateTime time;
  final String messageId;
  final bool isSeen;
  final String prof;
  final String proff;
  final String repliedMessage;
  final String repliedTo;
  final EnumData repliedMessageType;

  const MessageEntity({
    required this.senderId,
    required this.chatId,
    required this.text,
    required this.type,
    required this.time,
    required this.messageId,
    required this.isSeen,
    required this.prof,
    required this.proff,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });
}
