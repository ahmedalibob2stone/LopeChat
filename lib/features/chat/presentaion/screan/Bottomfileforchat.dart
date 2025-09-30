import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:lopechat/features/chat/presentaion/viewmodel/chat_massage/temp_messages_viewmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:extended_text_field/extended_text_field.dart';

import '../../../../common/Provider/Message_reply.dart';
import '../../../../common/Provider/providers.dart';
import '../../../../common/enums/enum_massage.dart';
import '../../../../common/utils/utills.dart';
import '../../../../common/widgets/link/link_span_widget.dart';
import '../../../../constant.dart';
import '../../../profile/presentation/provider/block/vm/viewmodel_provider.dart';
import '../../../user/presentation/provider/user_provider.dart';
import '../../domain/entities/chat message/local_blocked_massage.dart';

import '../provider/chat_massage/viewmodel/local_blocked_messages_view_model_provider.dart';
import '../provider/chat_massage/viewmodel/provider.dart';
import '../provider/chat_massage/viewmodel/temp_messages_view_model.dart';
import '../widgets/Message_reply.dart';

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

  Future<void> openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ShowSnakBar(context: context, content: 'تم رفض صلاحية الميكروفون!');
      return;
    }
    await _flutterSoundRecorder!.openRecorder();
    isRecorder = true;
  }

  void _addLocalBlockedMessage({
    required String text,
    required EnumData type,
    required String senderId,
    File? file,
    String? gifUrl,
    String? repliedText,
    EnumData? repliedMessageType, // يجب أن يكون EnumData وليس String
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
      repliedMessage: repliedText ?? '',
      repliedMessageType: repliedMessageType ?? EnumData.text, // القيمة الافتراضية
      isLocalBlocked: true,
    );

    ref.read(localBlockedMessagesProvider.notifier).addLocalBlockedMessage(local);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> sendTextMessage() async {
    // خزن النص في متغير مؤقت قبل مسحه
    final textToSend = _message.text.trim();

    final currentUser = ref.read(cachedCurrentUserProvider.notifier).state;
    if (currentUser == null) {
      print("⛔️ UI → بيانات المستخدم الحالي غير موجودة، لا يمكن إرسال الرسالة");
      return;
    }

    final messageReply = ref.read(messageReplyProvider);

    if (textToSend.isEmpty) {
      print("⚠️ UI → محاولة إرسال رسالة فارغة");
      return;
    }

    final url = _extractFirstUrl(textToSend);
    if (url != null) {
      // إذا الرسالة تحتوي على رابط، أرسلها كرسالة رابط
      sendLinkMessage(url);
      return;
    }

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final serverMessageId = 'msg_${DateTime.now().millisecondsSinceEpoch}';

    // إنشاء رسالة مؤقتة
    ref.read(tempMessageProvider.notifier).addTempMessage(
      TempMessage(
        id: tempId,
        type: EnumData.text,
        time: DateTime.now(),
        serverMessageId: serverMessageId,
        isSentToServer: false,
        isUploaded: true, // لأنها نصية لا تحتاج رفع ملف
        progress: 1.0,
        text: textToSend, link: "", gifUrl: '',
      ),
    );

    // مسح النص من الكيبورد بعد إنشاء المؤقتة
    _message.clear();

    print("🔍 UI → التحقق من إمكانية الإرسال إلى ${widget.chatId} ...");

    // التحقق من إمكانية الإرسال
    final result = await ref.read(blockUserViewModelProvider.notifier)
        .canSendMessage(currentUserId: currentUser.uid, receiverUserId: widget.chatId);

    await result.fold(
          (errorMsg) {
        // ممنوع الإرسال: حذف المؤقتة وإضافة رسالة محلية
        print("⛔️ UI → لا يمكن إرسال الرسالة: $errorMsg");

        _addLocalBlockedMessage(
          text: textToSend,
          type: EnumData.text,
          senderId: currentUser.uid,
          repliedText: messageReply?.message,
          repliedMessageType: messageReply?.messageDate,
        );

        ref.read(messageReplyProvider.notifier).state = null;
        ref.read(tempMessageProvider.notifier).removeTempMessage(tempId);
      },
          (canSend) async {
        if (!canSend) {
          // لم يُسمح بالإرسال لأي سبب آخر
          _addLocalBlockedMessage(
            text: textToSend,
            type: EnumData.text,
            senderId: currentUser.uid,
            repliedText: messageReply?.message,
            repliedMessageType: messageReply?.messageDate,
          );
          ref.read(messageReplyProvider.notifier).state = null;
          ref.read(tempMessageProvider.notifier).removeTempMessage(tempId);
          return;
        }

        try {
          print("✅ UI → مسموح بالإرسال. سيتم استدعاء VM");

          // استدعاء ViewModel لإرسال الرسالة الحقيقية
          final sentServerMessageId = await ref.read(sendMessageViewModelProvider.notifier)
              .sendTextMessage(
            text: textToSend,
            reciveUserId: widget.chatId,
            sendUser: currentUser,
            messageReply: messageReply,
            isGroupChat: widget.isGroupChat,
          );

          print("📩 UI → تم إرسال الرسالة: $textToSend إلى ${widget.chatId}");

          // تحديث الرسالة المؤقتة بعد وصولها للسيرفر
          ref.read(tempMessageProvider.notifier).markAsSent(tempId, sentServerMessageId);

          ref.read(messageReplyProvider.notifier).state = null;

          // تمرير التمرير إلى الأسفل
          ref.read(scrollToBottomProvider.notifier).state = true;
        } catch (e, st) {
          print("❌ Error sending text message: $e");
          print(st);

          // إزالة الرسالة المؤقتة عند الفشل
          ref.read(tempMessageProvider.notifier).removeTempMessage(tempId);
        }
      },
    );
  }




  Future<String> uploadFile(File file, Function(double) onProgress) async {
    // مثال على رفع ملف وهمي مع تحديث progress
    const totalChunks = 100;
    for (int i = 1; i <= totalChunks; i++) {
      await Future.delayed(const Duration(milliseconds: 20));
      onProgress(i / totalChunks); // تحديث التقدم
    }

    // بعد انتهاء الرفع، أرجع رابط الملف النهائي
    return file.path; // هنا يجب أن ترجع URL الملف من Storage فعلي
  }
  Future<void> sendFileMessage(File file, EnumData type) async {
    final currentUser = ref.read(cachedCurrentUserProvider.notifier).state;
    if (currentUser == null) return;

    final messageReply = ref.read(messageReplyProvider);

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final serverMessageId = 'msg_${DateTime.now().millisecondsSinceEpoch}';

    // إنشاء رسالة مؤقتة
    ref.read(tempMessageProvider.notifier).addTempMessage(
      TempMessage(
        id: tempId,
        file: file,
        type: type,
        time: DateTime.now(),
        serverMessageId: serverMessageId,
        progress: 0.0,        // نسبة رفع الملف تبدأ من 0
        isUploaded: false,    // الملف لم يُرفع بعد
        isSentToServer: false, text: '', link: '', gifUrl: '',
      ),
    );

    final result = await ref.read(blockUserViewModelProvider.notifier)
        .canSendMessage(
      currentUserId: currentUser.uid,
      receiverUserId: widget.chatId,
    );

    result.fold(
          (errorMsg) {
        // ممنوع الإرسال: حذف المؤقتة وإضافة رسالة محلية
        ref.read(tempMessageProvider.notifier).removeTempMessage(tempId);
        _addLocalBlockedMessage(
          text: file.path.split('/').last,
          type: type,
          senderId: currentUser.uid,
          file: file,
          repliedText: messageReply?.message,
          repliedMessageType: messageReply?.messageDate,
        );
        ref.read(messageReplyProvider.notifier).state = null;
      },
          (canSend) async {
        try {
          // رفع الملف مع تحديث نسبة التقدم
          // بعد رفع الملف
          final uploadedUrl = await uploadFile(file, (progress) {
            ref.read(tempMessageProvider.notifier).updateProgress(tempId, progress);
          });
          ref.read(tempMessageProvider.notifier).markUploadComplete(tempId);

// لا تستبدل الملف بعد الرفع!
// ref.read(tempMessageProvider.notifier).updateFile(tempId, uploadedUrl: uploadedUrl);

          // إرسال الرسالة إلى Firestore
          final sentServerMessageId = await ref.read(sendMessageViewModelProvider.notifier)
              .sendFileMessage(
            file: File(uploadedUrl),
            chatId: widget.chatId,
            senderUserDate: currentUser,
            massageEnum: type,
            messageReply: messageReply,
            isGroupChat: widget.isGroupChat,
          );

          // وضع الـ serverMessageId النهائي في نفس الرسالة
          ref.read(tempMessageProvider.notifier).markAsSent(tempId, sentServerMessageId);

          ref.read(scrollToBottomProvider.notifier).state = true;
          ref.read(messageReplyProvider.notifier).state = null;

        } catch (e) {
          // فشل الإرسال
          ref.read(tempMessageProvider.notifier).removeTempMessage(tempId);
          print("❌ Error sending file message: $e");
        }
      },
    );
  }

  Future<void> selectGIF() async {
    final currentUser = ref.read(cachedCurrentUserProvider.notifier).state;
    if (currentUser == null) {
      print("⛔️ UI → بيانات المستخدم الحالي غير موجودة، لا يمكن إرسال الرسالة");
      return;
    }

    final gif = await PickGif(context);
    final gifUrl = gif?.images?.original?.url;

    if (gifUrl == null || gifUrl.isEmpty) return;

    final messageReply = ref.read(messageReplyProvider);
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final serverMessageId = 'msg_${DateTime.now().millisecondsSinceEpoch}';

    ref.read(tempMessageProvider.notifier).addTempMessage(
      TempMessage(
        id: tempId,
        type: EnumData.gif,
        time: DateTime.now(),
        serverMessageId: serverMessageId,
        progress: 0.0,        // نسبة رفع الملف تبدأ من 0
        isUploaded: false,    // الملف لم يُرفع بعد
        isSentToServer: false, text: '', link: '', gifUrl: gifUrl,
      ),
    );

    final result = await ref.read(blockUserViewModelProvider.notifier)
        .canSendMessage(
      currentUserId: currentUser.uid,
      receiverUserId: widget.chatId,
    );

    result.fold(
          (errorMsg) {
        _addLocalBlockedMessage(
          text: gifUrl,
          type: EnumData.gif,
          senderId: currentUser.uid,
          repliedText: messageReply?.message,
          repliedMessageType: messageReply?.messageDate, // ✅ تأكد أن هذا من نوع EnumData
        );
        ref.read(messageReplyProvider.notifier).state = null;
      },
          (canSend)async {
            try{
              ref.read(tempMessageProvider.notifier).markUploadComplete(tempId);

              final sentServerMessageId = await  ref.read(sendMessageViewModelProvider.notifier).sendGIFMessage(
                gif: gifUrl,
                chatId: widget.chatId,
                sendUser: currentUser,
                messageReply: messageReply,
                isGroupChat: widget.isGroupChat,
              );
              ref.read(tempMessageProvider.notifier).markAsSent(tempId, sentServerMessageId);

              ref.read(scrollToBottomProvider.notifier).state = true;
              ref.read(messageReplyProvider.notifier).state = null;
            }catch(e){
              ref.read(tempMessageProvider.notifier).removeTempMessage(tempId);
              print("❌ Error sending file message: $e");
            }


      },
    );
  }
  void sendLinkMessage(String url) async {
    final currentUser = ref.read(cachedCurrentUserProvider.notifier).state;
    if (currentUser == null) {
      print("⛔️ UI → بيانات المستخدم الحالي غير موجودة، لا يمكن إرسال الرسالة");
      return;
    }

    final messageReply = ref.read(messageReplyProvider);
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final serverMessageId = 'msg_${DateTime.now().millisecondsSinceEpoch}';
    ref.read(tempMessageProvider.notifier).addTempMessage(
      TempMessage(
        id: tempId,
        type: EnumData.gif,
        time: DateTime.now(),
        serverMessageId: serverMessageId,
        progress: 0.0,        // نسبة رفع الملف تبدأ من 0
        isUploaded: false,    // الملف لم يُرفع بعد
        isSentToServer: false, text: '', link: url, gifUrl: "",
      ),
    );
    final result = await ref.read(blockUserViewModelProvider.notifier)
        .canSendMessage(
      currentUserId: currentUser.uid,
      receiverUserId: widget.chatId,
    );

    result.fold(
          (errorMsg) {
        _addLocalBlockedMessage(
          text: url,
          type: EnumData.link,
          senderId: currentUser.uid,
          repliedText: messageReply?.message,
          repliedMessageType: messageReply?.messageDate, // ✅ تأكد أن هذا من نوع EnumData
        );
        _message.clear();
        ref.read(messageReplyProvider.notifier).state = null;
      },
          (canSend)async {
            try{
              ref.read(tempMessageProvider.notifier).markUploadComplete(tempId);

              final sentServerMessageId= await ref.read(sendMessageViewModelProvider.notifier).sendTextMessage(
                text: url,
                sendUser: currentUser,
                messageReply: messageReply,
                isGroupChat: widget.isGroupChat, reciveUserId: widget.chatId,
              );
              ref.read(tempMessageProvider.notifier).markAsSent(tempId, sentServerMessageId);

              _message.clear();
              ref.read(messageReplyProvider.notifier).state = null;
              ref.read(scrollToBottomProvider.notifier).state = true;
            }catch(e){
              ref.read(tempMessageProvider.notifier).removeTempMessage(tempId);
              print("❌ Error sending file message: $e");
            }

      },
    );
  }

  Future<void> selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) sendFileMessage(image, EnumData.image);
  }

  Future<void> selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) sendFileMessage(video, EnumData.video);
  }
  Future<void> selectMedia(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.image, color: Colors.blue),
                title: const Text("Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  File? image = await pickImageFromGallery(context);
                  if (image != null) sendFileMessage(image, EnumData.image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam, color: Colors.green),
                title: const Text("Video"),
                onTap: () async {
                  Navigator.pop(context);
                  File? video = await pickVideoFromGallery(context);
                  if (video != null) sendFileMessage(video, EnumData.video);
                },
              ),
            ],
          ),
        );
      },
    );
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

  void handleAudioRecording() async {
    if (!isRecorder) return;

    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/flutter_sound.aac';

    if (isRecording) {
      final recordedPath = await _flutterSoundRecorder!.stopRecorder();
      setState(() => isRecording = false);
      if (recordedPath != null) sendFileMessage(File(recordedPath), EnumData.audio);
    } else {
      await _flutterSoundRecorder!.startRecorder(toFile: path);
      setState(() => isRecording = true);
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
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    return url;
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
                  prefixIcon: Row(
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
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => selectMedia(context),
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
                  sendLinkMessage(url);
                } else if (_message.text.trim().isNotEmpty) {
                  sendTextMessage();
                } else {
                  handleAudioRecording();
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
                if (!isShowsendmassage) setState(() => isShowsendmassage = true);
              },
            ),
          ),
      ],
    );
  }
}
