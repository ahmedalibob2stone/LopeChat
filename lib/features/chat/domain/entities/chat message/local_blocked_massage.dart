import '../../../../../../common/enums/enum_massage.dart';
import 'message_entity.dart';

class LocalBlockedMessage implements BaseMessage {
  @override
  final String messageId;

  @override
  final String chatId;

  @override
  final String text;
  final String? filePath;
  final String? gifUrl;

  @override
  final EnumData type;

  @override
  final String senderId;

  @override
  final DateTime time;

  @override
  final bool isSeen;

  @override
  final String repliedTo;

  @override
  final String repliedMessage;

  @override
  final EnumData repliedMessageType;

  @override
  final String prof;

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
    this.isSeen = false,
    this.repliedTo = '',
    this.repliedMessage = '',
    this.repliedMessageType = EnumData.text,
    this.prof = '',
    this.isLocalBlocked = true,
  });
}
