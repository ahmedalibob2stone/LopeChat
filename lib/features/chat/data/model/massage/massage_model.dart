
import 'package:lopechat/common/enums/enum_massage.dart';

import '../../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.senderId,
    required super.chatId,
    required super.text,
    required super.type,
    required super.time,
    required super.messageId,
    required super.isSeen,
    required super.prof,
    required super.proff,
    required super.repliedMessage,
    required super.repliedTo,
    required super.repliedMessageType,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] ?? '',
      chatId: map['chatId'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
      prof: map['prof'] ?? '',
      proff: map['proff'] ?? '',
      repliedMessage: map['repliedMessage'] ?? '',
      repliedTo: map['repliedTo'] ?? '',
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'chatId': chatId,
      'text': text,
      'type': type.type,
      'time': time.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'prof': prof,
      'proff': proff,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type,
    };
  }

  /// Optional: Convert Entity to Model
  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      senderId: entity.senderId,
      chatId: entity.chatId,
      text: entity.text,
      type: entity.type,
      time: entity.time,
      messageId: entity.messageId,
      isSeen: entity.isSeen,
      prof: entity.prof,
      proff: entity.proff,
      repliedMessage: entity.repliedMessage,
      repliedTo: entity.repliedTo,
      repliedMessageType: entity.repliedMessageType,
    );
  }
}
