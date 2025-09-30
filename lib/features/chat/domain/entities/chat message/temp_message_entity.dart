import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../common/enums/enum_massage.dart';
import '../../../presentaion/viewmodel/chat_massage/temp_messages_viewmodel.dart';
import 'message_entity.dart';

class TempMessageWrapper implements BaseMessage{
  final TempMessage temp;
  @override
  final String chatId;

  TempMessageWrapper(this.temp, this.chatId);

  factory TempMessageWrapper.fromTempMessage(TempMessage temp, String chatId) {
    return TempMessageWrapper(temp, chatId);
  }

  @override
  String get text {
    if (temp.type == EnumData.text) {
      return temp.text ?? ""; // النص الحقيقي للرسالة
    } else if (temp.file != null) {
      return temp.file!.path.split('/').last; // اسم الملف
    }
    return "";
  }


  @override
  DateTime get time => temp.time;

  @override
  String get senderId => FirebaseAuth.instance.currentUser!.uid;

  @override
  EnumData get type => temp.type;

  @override
  bool get isSeen => false;

  // أعطي قيم افتراضية لتوافق الـ interface
  @override
  String get repliedMessage => "";

  @override
  EnumData get repliedMessageType => EnumData.text;

  @override
  String get repliedTo => "";

  @override
  String get prof => "";

  @override
  String get proff => "";

  @override
  String get messageId => temp.serverMessageId ?? temp.id;

}
