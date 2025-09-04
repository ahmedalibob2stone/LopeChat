import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_sound/flutter_sound.dart';

import '../../../../common/Provider/Message_reply.dart';
import '../../../../common/Provider/providers.dart';
import '../../../../common/enums/enum_massage.dart';
import '../../../../common/utils/utills.dart';
import '../../../../common/widgets/link/link_span_widget.dart';
import '../../../../constant.dart';
import '../../../profile/data/model/block/local_blocked_massage.dart';
import '../../../profile/presentation/provider/block/vm/local_blocked_massages_provider.dart';
import '../../../profile/presentation/provider/block/vm/viewmodel_provider.dart';
import '../../../user/data/user_model/user_model.dart';
import '../../../user/presentation/provider/stream_provider/get_user_data_stream_provider.dart';
import '../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../provider/chat_massage/viewmodel/provider.dart';
import '../widgets/Message_reply.dart';
import 'package:extended_text_field/extended_text_field.dart';


class BottomFileforChat extends ConsumerStatefulWidget {
  final String chatId;
  final bool isGroupChat;

  const BottomFileforChat({
    required this.chatId,
    required this.isGroupChat,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<BottomFileforChat> createState() => _BottomFileforChatState();
}

class _BottomFileforChatState extends ConsumerState<BottomFileforChat> {
  final TextEditingController _message = TextEditingController();
  final FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? _flutterSoundRecorder;
  final List<Map<String, dynamic>> _localBlockedMessages = [];
  bool isShowsendmassage = false;
  bool isShowEmoji = false;
  bool isRecorder = false;
  bool isRecording = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _flutterSoundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  @override
  void dispose() {
    _message.dispose();
    _flutterSoundRecorder?.closeRecorder();
    _flutterSoundRecorder = null;
    super.dispose();
  }
  void _addLocalBlockedMessage({
    required String text,
    required EnumData type,
    required String senderId,
    File? file,
    String? gifUrl,
    String? repliedText,
    String? repliedMessageType,
  }) {
    final local = LocalBlockedMessage(
      messageId: 'local_${DateTime.now().millisecondsSinceEpoch}',
      chatId: widget.chatId,
      text: text,
      filePath: file?.path,
      gifUrl: gifUrl,
      type: type,
      senderId: senderId,
      time: DateTime.now(),
      repliedMessage: repliedText,
      repliedMessageType: repliedMessageType,
      isLocalBlocked: true,
    );

    ref.read(localBlockedMessagesProvider.notifier).addLocalBlockedMessage(local);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }




  Future<void> openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic not allowed!');
    }
    await _flutterSoundRecorder!.openRecorder();
    isRecorder = true;
  }

  Future<UserModel?> _getCurrentUserModel(BuildContext context) async {
    final currentUserEntity = await ref.read(currentUserStreamProvider.stream).first;
    if (currentUserEntity == null) {
      ShowSnakBar(context: context, content: 'لم يتم تحميل بيانات المستخدم');
      return null;
    }
    return UserModel.fromEntity(currentUserEntity);
  }

  void sendTextMassage() async {
    final currentUserModel = await _getCurrentUserModel(context);
    if (currentUserModel == null) return;

    final messageReply = ref.read(messageReplyProvider);

    if (isShowsendmassage) {



      final result = await ref
          .read(blockUserViewModelProvider.notifier)
          .canSendMessage(
        currentUserId: currentUserModel.uid,
        receiverUserId: widget.chatId,
      );

      result.fold(
            (errorMsg) {
          _addLocalBlockedMessage(
            text: _message.text.trim(),
            type: EnumData.text,
            senderId: currentUserModel.uid,
            repliedText: messageReply?.message,
            repliedMessageType:  messageReply?.messageDate.toString(),
            file: null

          );
          ref.read(messageReplyProvider.notifier).state = null;
          setState(() => _message.clear());
        },
            (canSend) {
              ref.read(sendMessageViewModelProvider.notifier).sendTextMessage(
                text: _message.text.trim(),
                reciveUserId: widget.chatId,
                sendUser: currentUserModel,
                messageReply: messageReply,
                isGroupChat: widget.isGroupChat,
              );
              ref.read(scrollToBottomProvider.notifier).state = true;

              ref.read(messageReplyProvider.notifier).state = null;
              setState(() => _message.clear());
        },
      );
    } else {
      // قسم التسجيل (الصوت) كما كان عندك بالضبط
      var temp = await getTemporaryDirectory();
      var path = '${temp.path}/flutter_sound.aac';

      if (!isRecorder) return;

      if (isRecording) {
        await _flutterSoundRecorder!.stopRecorder();
        sendFileMessage(File(path), EnumData.audio);
      } else {
        await _flutterSoundRecorder!.startRecorder(toFile: path);
      }

      setState(() => isRecording = !isRecording);
    }
  }
  String? _extractFirstUrl(String input) {
    final regex = RegExp(
      r'((https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(\/\S*)?)',
      caseSensitive: false,
    );
    final match = regex.firstMatch(input);
    if (match == null) return null;

    var url = match.group(0)!;
    // لو ما في scheme ضِف https://
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    return url;
  }

  void sendLinkMassage() async {
    final url = _extractFirstUrl(_message.text.trim())!;

    final currentUserModel = await _getCurrentUserModel(context);
    if (currentUserModel == null) return;

    final messageReply = ref.read(messageReplyProvider);

    if (isShowsendmassage) {



      final result = await ref
          .read(blockUserViewModelProvider.notifier)
          .canSendMessage(
        currentUserId: currentUserModel.uid,
        receiverUserId: widget.chatId,
      );

      result.fold(
            (errorMsg) {
          _addLocalBlockedMessage(
              text:url,
              type: EnumData.link,
              senderId: currentUserModel.uid,
              repliedText: messageReply?.message,
              repliedMessageType:  messageReply?.messageDate.toString(),
              file: null

          );
          ref.read(messageReplyProvider.notifier).state = null;
          setState(() => _message.clear());
        },
            (canSend) {
          ref.read(sendMessageViewModelProvider.notifier).sendLinkMessage(
            link: url.trim(),
            reciveUserId: widget.chatId,
            sendUser: currentUserModel,
            messageReply: messageReply,
            isGroupChat: widget.isGroupChat,
          );
          ref.read(scrollToBottomProvider.notifier).state = true;

          ref.read(messageReplyProvider.notifier).state = null;
          setState(() => _message.clear());
        },
      );
    } else {
      var temp = await getTemporaryDirectory();
      var path = '${temp.path}/flutter_sound.aac';

      if (!isRecorder) return;

      if (isRecording) {
        await _flutterSoundRecorder!.stopRecorder();
        sendFileMessage(File(path), EnumData.audio);
      } else {
        await _flutterSoundRecorder!.startRecorder(toFile: path);
      }

      setState(() => isRecording = !isRecording);
    }
  }


  void sendFileMessage(File file, EnumData messageData) async {
    final currentUserModel = await _getCurrentUserModel(context);
    if (currentUserModel == null) return;

    final messageReply = ref.read(messageReplyProvider);

    final result = await ref
        .read(blockUserViewModelProvider.notifier)
        .canSendMessage(
      currentUserId: currentUserModel.uid,
        receiverUserId: widget.chatId,
    );

    result.fold(
          (errorMsg) {
        // المستخدم محظور → نضيف الرسالة محليًا مع علامة التحذير
        _addLocalBlockedMessage(
          text: file.path.split('/').last, // اسم الملف
          type: messageData,
          senderId: currentUserModel.uid,
          repliedText: messageReply?.message,
          repliedMessageType: messageReply?.messageDate.toString(),
          file: file

        );
        ref.read(messageReplyProvider.notifier).state = null;
        setState(() => _message.clear());

      },
          (canSend) {
        // إرسال الملف إذا مسموح
        ref.read(sendMessageViewModelProvider.notifier).sendFileMessage(
          file: file,
          chatId: widget.chatId,
          senderUserDate: currentUserModel,
          massageEnum: messageData,
          messageReply: messageReply,
          isGroupChat: widget.isGroupChat,
        );
        ref.read(scrollToBottomProvider.notifier).state = true;

        ref.read(messageReplyProvider.notifier).state = null;
      },
    );
  }



  Future<void> selectGIF() async {
    final currentUserModel = await _getCurrentUserModel(context);
    if (currentUserModel == null) return;

    final gif = await PickGif(context);
    final gifUrl = gif?.images?.original?.url;

    if (gifUrl != null && gifUrl.isNotEmpty) {
      final messageReply = ref.read(messageReplyProvider);

      ref.read(blockUserViewModelProvider.notifier)
          .canSendMessage(
        currentUserId: currentUserModel.uid,
          receiverUserId: widget.chatId,
      )
          .then((result) {
        result.fold(
              (errorMsg) {
            // مستخدم محظور → حفظ الرسالة محلياً مع الأيقونة الحمراء
            _addLocalBlockedMessage(
              text: gifUrl, // تخزين رابط الـ GIF كنص
              type: EnumData.gif,
              senderId: currentUserModel.uid,
              repliedText: messageReply?.message,
              repliedMessageType: messageReply?.messageDate.toString(),
              file: null
            );
            ref.read(messageReplyProvider.notifier).state = null;
            setState(() => _message.clear());
          },
              (canSend) {
            // إرسال GIF عادي
            ref.read(sendMessageViewModelProvider.notifier).sendGIFMessage(
              gif: gifUrl,
              chatId: widget.chatId,
              sendUser: currentUserModel,
              messageReply: messageReply,
              isGroupChat: widget.isGroupChat,
            );
            ref.read(scrollToBottomProvider.notifier).state = true;

            ref.read(messageReplyProvider.notifier).state = null;
          },
        );

      });
    } else {
    }
  }


  Future<void> selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, EnumData.image);
    }
  }

  Future<void> selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, EnumData.video);
    }
  }


  void toggleEmojiKeyboard() {
    if (isShowEmoji) {
      focusNode.requestFocus();
      setState(() => isShowEmoji = false);
    } else {
      focusNode.unfocus();
      setState(() => isShowEmoji = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageState = ref.watch(messageViewModelProvider);
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    return Column(
      children: [
        if (isShowMessageReply) const Message_Reply(),
        Row(
          children: <Widget>[
            Expanded(
              child: ExtendedTextField(
                focusNode: focusNode,
                controller: _message,
                maxLines: 4,
                minLines: 1,
                specialTextSpanBuilder: LinkTextSpanBuilder(),

                autocorrect: true,
                onChanged: (val) => setState(() => isShowsendmassage = val.isNotEmpty),
                decoration: InputDecoration(
                  hintText: "Message...",
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: toggleEmojiKeyboard,
                          icon: const Icon(Icons.emoji_emotions, color: kkPrimaryColor, size: 20),
                        ),
                        IconButton(
                          onPressed: selectGIF,
                          icon: const Icon(Icons.gif_outlined, color: kkPrimaryColor, size: 30),
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: selectVideo,
                        icon: const Icon(Icons.attach_file, color: kkPrimaryColor, size: 20),
                      ),
                      IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.camera_alt, color: kkPrimaryColor, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            FloatingActionButton(
              onPressed: () {
                final url = _extractFirstUrl(_message.text.trim());
                if (url != null) {
                  sendLinkMassage();
                } else {
                  sendTextMassage();
                }
              },

              backgroundColor: kkPrimaryColor,
              child: messageState.isSending
                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  : Icon(
                isShowsendmassage
                    ? Icons.send
                    : isRecording
                    ? Icons.close
                    : Icons.mic,
                color: const Color(0xFFF5FCF9),
                size: 18,
              ),
            ),
          ],
        ),
        if (isShowEmoji)
          SizedBox(
            height: 310,
            child: EmojiPicker(
              onEmojiSelected: (type, emoji) {
                setState(() => _message.text += emoji.emoji);
                if (!isShowsendmassage) {
                  setState(() => isShowsendmassage = true);
                }
              },
            ),
          ),
      ],
    );
  }
}