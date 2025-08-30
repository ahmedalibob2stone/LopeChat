import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/enum_massage.dart';



class MessageReply {

  final String message;
  final bool isMe;
  final EnumData messageDate;

  MessageReply({required this.message,required this.isMe,required this.messageDate});

}

final messageReplyProvider = StateProvider<MessageReply?>((ref) =>null);










// final EnumData messageDate;