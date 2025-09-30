
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../common/enums/enum_massage.dart';
import '../../../../constant.dart';
import '../../domain/entities/chat message/temp_message_entity.dart';
import '../provider/chat_massage/viewmodel/provider.dart';
import 'DisplayTypeofMassage.dart';
import 'VideoPlayer.dart';

class MyMessageCard extends ConsumerWidget {
  final String message;
  final String date;
  final EnumData type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final EnumData repliedMessageType;
  final String uid;
  final bool isSeen;
  final String chatId;
  final String messageId;
  final String profileUrl;
  final bool isLocalBlocked;
  final bool isTempMessage;
  final TempMessageWrapper? tempMessage;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.uid,
    required this.chatId,
    required this.messageId,
    required this.isSeen,
    required this.profileUrl,
    this.isLocalBlocked = false,
    this.isTempMessage = false,
    this.tempMessage,
  }) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReplying = repliedText.isNotEmpty;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return SwipeTo(
      onLeftSwipe: (_) => onLeftSwipe(),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width * 0.8),
          child: Stack(
            children: [
              _buildMessageCard(context, ref, isReplying),
              if (isLocalBlocked)
                Positioned(
                  right: 5,
                  top: 5,
                  child: CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.error, size: 10, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageCard(BuildContext context, WidgetRef ref,
      bool isReplying) {
    return InkWell(
      onLongPress: () => _onMessageLongPress(context, ref),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: messageCard,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Stack(
          children: [
            Padding(
              padding: type == EnumData.text
                  ? const EdgeInsets.fromLTRB(20, 5, 25, 20)
                  : const EdgeInsets.fromLTRB(5, 5, 5, 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isReplying) _buildReplyMessage(context),
                  _buildMessageContent(context),
                ],
              ),
            ),
            _buildTimestampAndSeenIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyMessage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: Theme
              .of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 3),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: _buildMessageContent(context),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTimestampAndSeenIcon() {
    return Positioned(
      bottom: 4,
      right: 5,
      child: Row(
        children: [
          Text(
            date,
            style: const TextStyle(fontSize: 10, color: Colors.white60),
          ),
          const SizedBox(width: 1),
          Icon(
            isTempMessage ? Icons.access_time : (isSeen ? Icons.done_all : Icons
                .done),
            size: 15,
            color: isTempMessage ? Colors.grey : (isSeen ? Colors.blue : Colors
                .white60),
          ),

        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: CircleAvatar(
        backgroundColor: Colors.grey.withValues(),
        radius: 20,
        backgroundImage: CachedNetworkImageProvider(profileUrl),
      ),
    );
  }

  void _onMessageLongPress(BuildContext context, WidgetRef ref) {
    if (uid == FirebaseAuth.instance.currentUser!.uid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: const Text("Delete Message"),
                onPressed: () {
                  ref
                      .read(deleteMessageViewModelProvider.notifier)
                      .deleteMessage(
                    context: context,
                    chatId: chatId,
                    messageId: messageId,
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  RichText _buildRichText(String text) {
    final linkRegex = RegExp(
      r'((https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(\/\S*)?)',
      caseSensitive: false,
    );

    List<InlineSpan> children = [];
    int start = 0;

    for (final match in linkRegex.allMatches(text)) {
      if (match.start > start) {
        children.add(TextSpan(
            text: text.substring(start, match.start),
            style: const TextStyle(color: Colors.white)));
      }
      final url = text.substring(match.start, match.end);
      children.add(
        TextSpan(
          text: url,
          style: const TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final uri =
              Uri.parse(url.startsWith('http') ? url : 'https://$url');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
        ),
      );
      start = match.end;
    }

    if (start < text.length) {
      children.add(TextSpan(
          text: text.substring(start),
          style: const TextStyle(color: Colors.white)));
    }

    return RichText(text: TextSpan(children: children));
  }

  Widget _buildMessageContent(BuildContext context) {
    if (isTempMessage && tempMessage != null) {
      final temp = tempMessage!.temp;

      switch (type) {
        case EnumData.text:
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.55, // نفس قيود DisplayTypeofMassage
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRichText(message),
                if (temp.showProgress)
                  LinearProgressIndicator(
                    value: temp.progressValue,
                    color: Colors.blue,
                    backgroundColor: Colors.grey[300],
                  ),
              ],
            ),
          );

        case EnumData.image:
          final imageFile = temp.file;
          final uploadedUrl = temp.uploadedUrl;

          return Stack(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.66,
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: uploadedUrl != null
                      ? Image.network( // بعد الانتهاء من الرفع
                    uploadedUrl,
                    fit: BoxFit.cover,
                  )
                      : (imageFile != null
                      ? Image.file( // أثناء الرفع
                    imageFile,
                    fit: BoxFit.cover,
                  )
                      : const SizedBox()),
                ),
              ),
              if (temp.showProgress)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: temp.progressValue, // نسبة التقدم
                    color: Colors.blue,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
            ],
          );


        case EnumData.video:
          final file = temp.file!;
          return Stack(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CustomVideoPlayer(
                    videoUrl: file.path,
                  ),
                ),
              ),
              if (temp.showProgress)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: temp.progressValue,
                    color: Colors.blue,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
            ],
          );


        case EnumData.audio:
          bool isPlaying = false;
          return Stack(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.55,
                  maxHeight: 65, // ارتفاع زر الصوت
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: Colors.black12,
                    child: Center(
                      child: IconButton(
                        iconSize: 36,
                        icon: Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: Colors.grey.shade700,
                        ),
                        onPressed: () async {

                        },
                      ),
                    ),
                  ),
                ),
              ),
              if (temp.showProgress)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: temp.progressValue,
                    color: Colors.blue,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
            ],
          );

        case EnumData.gif:
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.66,
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: temp.file != null
                  ? Image.file(temp.file!, fit: BoxFit.cover)
                  : const Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
          );

        case EnumData.link:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRichText(message), // هنا استخدم RichText بدل Text عادي
              if (temp.showProgress)
                LinearProgressIndicator(
                  value: temp.progressValue,
                  color: Colors.blue,
                  backgroundColor: Colors.grey[300],
                ),
            ],
          );

      }
    } else {
      return DisplayTypeofMassage(message: message, type: type);
    }
  }
}
