  import 'package:flutter/material.dart';
  import 'package:flutter/scheduler.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:intl/intl.dart';

  import '../../../../common/Provider/Message_reply.dart';
  import '../../../../common/enums/enum_massage.dart';
  import '../../../../common/widgets/Loeading.dart';
  import '../../../profile/presentation/provider/block/vm/local_blocked_massages_provider.dart';
  import '../../domain/entities/chat message/local_blocked_massage.dart';
  import '../../domain/entities/chat message/message_entity.dart';
  import '../../domain/entities/chat message/temp_message_entity.dart';
  import '../provider/chat_massage/viewmodel/chat_stream_provider.dart';
  import '../provider/chat_massage/viewmodel/local_blocked_messages_view_model_provider.dart';
  import '../provider/chat_massage/viewmodel/provider.dart';
  import '../provider/chat_massage/viewmodel/temp_messages_view_model.dart';
  import '../widgets/MyMessageCard.dart';
  import '../widgets/senderMassage.dart';



  class ChatList extends ConsumerStatefulWidget {
    const ChatList({
      Key? key,
      required this.isGroupChat,
      required this.reciverUserId,
    }) : super(key: key);

    final String reciverUserId;
    final bool isGroupChat;

    @override
    ConsumerState<ChatList> createState() => ChatListState();
  }

  class ChatListState extends ConsumerState<ChatList> {

    final ScrollController _messageController = ScrollController();
    List<String> getAllMedia() {
      final allMessages = ref.read(chatMessagesProvider(widget.reciverUserId)).maybeWhen(
        data: (messages) => messages,
        orElse: () => [],
      );

      final localMessages = ref.read(localBlockedMessagesProvider);
      final tempMessages = ref.read(tempMessageProvider);

      final combined = [
        ...allMessages,
        ...localMessages.where((m) => m.chatId == widget.reciverUserId),
        ...tempMessages
            .where((t) => !t.isSentToServer && t.serverMessageId == null)
            .map((t) => TempMessageWrapper.fromTempMessage(t, widget.reciverUserId)),
      ];

      return combined
          .where((m) =>
      _extractType(m) == EnumData.image ||
          _extractType(m) == EnumData.gif ||
          _extractType(m) == EnumData.video)
          .map((m) => _extractText(m))
          .toList();
    }
    @override
    void dispose() {
      _messageController.dispose();
      super.dispose();
    }

    void replyToMessage(String message, bool isMe, EnumData enumData) {
      ref.read(messageReplyProvider.notifier).state =
          MessageReply(message: message, isMe: isMe, messageDate: enumData);
    }

    @override
    Widget build(BuildContext context) {

      void _onMessageSwipe(String message, bool isMe, EnumData enumData) {
        ref.read(messageReplyProvider.notifier).state =
            MessageReply(message: message, isMe: isMe, messageDate: enumData);
      }
      final localMessages = ref.watch(localBlockedMessagesProvider);
      final tempMessages = ref.watch(tempMessageProvider);

      final messagesAsync = ref.watch(chatMessagesProvider(widget.reciverUserId));

      return LayoutBuilder(
        builder: (context, constraints) {

          return messagesAsync.when(
            loading: () => const Loeading(),
            error: (err, _) => Center(child: Text('حدث خطأ: $err')),
            data: (messages) {
              // 1) جمع جميع الرسائل
              final combined = [
                ...messages, // رسائل Firestore
                ...localMessages.where((m) => m.chatId == widget.reciverUserId),
                ...tempMessages.map((t) => TempMessageWrapper.fromTempMessage(t, widget.reciverUserId)),
              ];

              // 2) استبدال الرسائل المؤقتة بالرسائل الفعلية إذا تم إرسالها
              final allMessages = combined.where((msg) {
                if (msg is TempMessageWrapper && msg.temp.isSentToServer) {
                  // إذا الرسالة المؤقتة تم إرسالها بالفعل، تجاهلها إذا موجودة في Firestore
                  return !messages.any((fm) => fm.messageId == msg.temp.serverMessageId);
                }
                return true;
              }).toList();

              // 3) ترتيب حسب الوقت
              allMessages.sort((a, b) => _extractTime(a).compareTo(_extractTime(b)));

              // 4) التمرير التلقائي لأسفل
              SchedulerBinding.instance.addPostFrameCallback((_) {
                if (_messageController.hasClients) {
                  _messageController.jumpTo(_messageController.position.maxScrollExtent);
                }
              });

              return ListView.builder(
                controller: _messageController,
                itemCount: allMessages.length,
                itemBuilder: (context, index) {
                  final currentMessage = allMessages[index];

                  final previousMessage = index > 0 ? allMessages[index - 1] : null;

                  bool showDateHeader = false;
                  if (previousMessage == null ||
                      currentMessage.time.day != previousMessage.time.day) {
                    showDateHeader = true;
                  }

                  final bool isLocalBlocked = currentMessage is LocalBlockedMessage;
                  final bool isTempMessage = currentMessage is TempMessageWrapper;
                  final TempMessageWrapper? tempMessage =
                  isTempMessage ? currentMessage as TempMessageWrapper : null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDateHeader)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: constraints.maxHeight * 0.01,
                          ),
                          child: Center(
                            child: Text(
                              DateFormat('EEEE, MMMM d, yyyy').format(
                                _extractTime(currentMessage),
                              ),
                              style: TextStyle(
                                fontSize: constraints.maxHeight * 0.02,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      if (_extractSenderId(currentMessage) == FirebaseAuth.instance.currentUser!.uid)
                        MyMessageCard(
                  key: isTempMessage && tempMessage != null
                  ? ValueKey(tempMessage!.temp.id)
                      : ValueKey(_extractMessageId(currentMessage)),

                          message: _extractText(currentMessage),
                          date: DateFormat.Hm().format(_extractTime(currentMessage)),
                          type: _extractType(currentMessage),
                          repliedText: _extractRepliedMessage(currentMessage),
                          onLeftSwipe: () => _onMessageSwipe(
                            _extractText(currentMessage),
                            true,
                            _extractType(currentMessage),
                          ),
                          username: _extractRepliedTo(currentMessage),
                          repliedMessageType: _extractRepliedMessageType(currentMessage),
                          uid: _extractSenderId(currentMessage),
                          chatId: _extractChatId(currentMessage),
                          messageId: _extractMessageId(currentMessage),
                          isSeen: _extractIsSeen(currentMessage),
                          profileUrl: _extractProfileUrl(currentMessage),
                          isLocalBlocked: isLocalBlocked,
                          isTempMessage: isTempMessage,
                          tempMessage: tempMessage,
                        )
                      else
                        Column(
                          children: [
                            if (!currentMessage.isSeen &&
                                currentMessage.senderId != FirebaseAuth.instance.currentUser!.uid)
                              FutureBuilder(
                                future: ref
                                    .read(chatDisplayViewModelProvider.notifier)
                                    .markMessageAsSeen(
                                  currentMessage.chatId,
                                  currentMessage.messageId,
                                ),
                                builder: (context, snapshot) {
                                  return const SizedBox(); // تنفيذ فقط
                                },
                              ),
                            SenderMessageCard(
                              message: _extractText(currentMessage),
                              date: DateFormat.Hm().format(_extractTime(currentMessage)),
                              type: _extractType(currentMessage),
                              onRightSwipe: () => _onMessageSwipe(
                                _extractText(currentMessage),
                                false,
                                _extractType(currentMessage),
                              ),
                              username: _extractRepliedTo(currentMessage),
                              repliedMessageType: _extractRepliedMessageType(currentMessage),
                              repliedText: _extractRepliedMessage(currentMessage),
                              prof: _extractProfileUrl(currentMessage),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              );
            }
            ,
          );

        },
      );

    }

  }
  DateTime _extractTime(dynamic msg) {
    if (msg is MessageEntity) return msg.time;
    if (msg is LocalBlockedMessage) return msg.time;
    if (msg is TempMessageWrapper) return msg.time;
    throw Exception("Unknown message type: ${msg.runtimeType}");
  }

  String _extractText(dynamic msg) {
    if (msg is MessageEntity) return msg.text;
    if (msg is TempMessageWrapper) return msg.text;
    return '';
  }

  EnumData _extractType(dynamic msg) {
    if (msg is MessageEntity) return msg.type;
    if (msg is TempMessageWrapper) return msg.type;
    return EnumData.text;
  }

  String _extractRepliedMessage(dynamic msg) {
    if (msg is MessageEntity) return msg.repliedMessage;
    if (msg is TempMessageWrapper) return msg.repliedMessage;
    return '';
  }

  String _extractRepliedTo(dynamic msg) {
    if (msg is MessageEntity) return msg.repliedTo;
    if (msg is TempMessageWrapper) return msg.repliedTo;
    return '';
  }

  EnumData _extractRepliedMessageType(dynamic msg) {
    if (msg is MessageEntity) return msg.repliedMessageType;
    if (msg is TempMessageWrapper) return msg.repliedMessageType;
    return EnumData.text;
  }

  String _extractSenderId(dynamic msg) {
    if (msg is MessageEntity) return msg.senderId;
    if (msg is TempMessageWrapper) return msg.senderId;
    return '';
  }

  String _extractChatId(dynamic msg) {
    if (msg is MessageEntity) return msg.chatId;
    if (msg is TempMessageWrapper) return msg.chatId;
    return '';
  }

  String _extractMessageId(dynamic msg) {
    if (msg is MessageEntity) return msg.messageId;
    if (msg is TempMessageWrapper) return msg.messageId;
    return '';
  }

  bool _extractIsSeen(dynamic msg) {
    if (msg is MessageEntity) return msg.isSeen;
    if (msg is TempMessageWrapper) return msg.isSeen;
    return false;
  }

  String _extractProfileUrl(dynamic msg) {
    if (msg is MessageEntity) return msg.prof;
    if (msg is TempMessageWrapper) return msg.prof;
    return '';
  }
