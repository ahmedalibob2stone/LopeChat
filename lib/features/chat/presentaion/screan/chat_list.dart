import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../../common/Provider/Message_reply.dart';
import '../../../../common/enums/enum_massage.dart';
import '../../../../common/widgets/Loeading.dart';
import '../../../profile/data/model/block/local_blocked_massage.dart';
import '../../../profile/presentation/provider/block/vm/local_blocked_massages_provider.dart';
import '../../domain/entities/message_entity.dart';
import '../provider/chat_massage/viewmodel/chat_stream_provider.dart';
import '../provider/chat_massage/viewmodel/provider.dart';
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
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {

  final ScrollController _messageController = ScrollController();

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

    final messagesAsync = ref.watch(chatMessagesProvider(widget.reciverUserId));

    return LayoutBuilder(
      builder: (context, constraints) {

        return messagesAsync.when(
          loading: () => const Loeading(),
          error: (err, _) => Center(child: Text('حدث خطأ: $err')),
          data: (messages) {
            final allMessages = [
              ...messages,
              ...localMessages.where((m) => m.chatId == widget.reciverUserId),
            ];
            allMessages.sort((a, b) {
              DateTime timeA;
              DateTime timeB;

              if (a is LocalBlockedMessage) {
                timeA = a.time;
              } else {
                timeA = (a as MessageEntity).time;
              }

              if (b is LocalBlockedMessage) {
                timeB = b.time;
              } else {
                timeB = (b as MessageEntity).time;
              }

              return timeA.compareTo(timeB);
            });


            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (_messageController.hasClients) {
                _messageController.jumpTo(_messageController.position.maxScrollExtent);
              }
            });

            return ListView.builder(
              controller: _messageController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final currentMessage = messages[index];

                final previousMessage = index > 0 ? messages[index - 1] : null;

                bool showDateHeader = false;
                if (previousMessage == null ||
                    currentMessage.time.day != previousMessage.time.day) {
                  showDateHeader = true;
                }


                final bool isLocalBlocked = currentMessage is LocalBlockedMessage;
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
                              currentMessage.time,
                            ),
                            style: TextStyle(
                              fontSize: constraints.maxHeight * 0.02,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    if (currentMessage.senderId == FirebaseAuth.instance.currentUser!.uid)
                      MyMessageCard(
                        message: currentMessage.text,
                        date: DateFormat.Hm().format(currentMessage.time),
                        type: currentMessage.type,
                        repliedText: currentMessage.repliedMessage,
                        onLeftSwipe: () => _onMessageSwipe(
                          currentMessage.text,
                          true,
                          currentMessage.type,
                        ),
                        username: currentMessage.repliedTo,
                        repliedMessageType: currentMessage.repliedMessageType,
                        uid: currentMessage.senderId,
                        chatId: currentMessage.chatId ,
                        messageId: currentMessage.messageId,
                        isSeen: currentMessage.isSeen,
                        profileUrl: currentMessage.prof,
                        isLocalBlocked: isLocalBlocked,
                      )
                    else
                      Column(
                        children: [
                          if (!currentMessage.isSeen &&
                              currentMessage.senderId != FirebaseAuth.instance.currentUser!.uid)
                            FutureBuilder(
                              future: ref
                                  .read(chatDisplayViewModelProvider.notifier).markMessageAsSeen(

                                currentMessage.chatId ,
                                currentMessage.messageId,
                              ),
                              builder: (context, snapshot) {
                                return const SizedBox(); // لا نعرض شيء - فقط تنفيذ
                              },
                            ),
                          SenderMessageCard(
                            message: currentMessage.text,
                            date: DateFormat.Hm().format(currentMessage.time),
                            type: currentMessage.type,
                            onRightSwipe: () => _onMessageSwipe(
                              currentMessage.text,
                              false,
                              currentMessage.type,
                            ),
                            username: currentMessage.repliedTo,
                            repliedMessageType: currentMessage.repliedMessageType,
                            repliedText: currentMessage.repliedMessage,
                            prof: currentMessage.prof,
                          ),
                        ],
                      ),

                  ],
                );
              },
            );
          },
        );

      },
    );

  }

  }
