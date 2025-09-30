import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/helper snackbar/helper_snackbar.dart';
import '../../../user/presentation/provider/user_provider.dart';
import '../provider/viewmodel/upload_status_viewmodel_provider.dart';

class AddInformationStatus extends ConsumerStatefulWidget {
  final File file;

  const AddInformationStatus({required this.file, Key? key}) : super(key: key);

  @override
  _AddInformationStatusState createState() => _AddInformationStatusState();
}

class _AddInformationStatusState extends ConsumerState<AddInformationStatus> {
  final TextEditingController _messageController = TextEditingController();
  bool _isShowEmoji = false;
  FocusNode _focusNode = FocusNode();
  double _verticalDrag = 0;

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleEmojiKeyboard() {
    setState(() {
      _isShowEmoji = !_isShowEmoji;
      if (_isShowEmoji) _focusNode.unfocus();
      else _focusNode.requestFocus();
    });
  }

  void _addStatus(WidgetRef ref) {
    final currentUser = ref.read(cachedCurrentUserProvider.notifier).state;
    if (currentUser == null) return;

    ref.read(uploadStatusViewModelProvider.notifier).uploadStatus(
      file: widget.file,
      message: _messageController.text.trim(),
      username: currentUser.name,
      profile: currentUser.profile,
      phoneNumber: currentUser.phoneNumber,
      seenBy: {},
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(uploadStatusViewModelProvider, (previous, state) {
      if (state.error != null) {
        // حالة فشل
        AppSnackbar.showError(context, state.error!);
      } else if (state.success && state.message != null) {
        // حالة نجاح: عرض Snackbar ثم العودة تلقائيًا
        AppSnackbar.showSuccess(context, state.message!);
        Future.delayed(const Duration(milliseconds: 500), () {
          ref.read(uploadStatusViewModelProvider.notifier).resetState();
          Navigator.pop(context);
        });
      }
    });

    final state = ref.watch(uploadStatusViewModelProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // الصورة القابلة للتكبير والتصغير
          GestureDetector(
            onVerticalDragUpdate: (details) {
              setState(() {
                _verticalDrag += details.delta.dy;
              });
            },
            onVerticalDragEnd: (details) {
              if (_verticalDrag > screenHeight * 0.2) {
                Navigator.pop(context); // السحب للإلغاء
              }
              setState(() {
                _verticalDrag = 0;
              });
            },
            child: Transform.translate(
              offset: Offset(0, _verticalDrag),
              child: InteractiveViewer(
                panEnabled: true,
                scaleEnabled: true,
                child: Image.file(
                  widget.file,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),

          // طبقة سوداء شفافة لتحسين النصوص
          Positioned.fill(
            child: Container(color: Colors.black38),
          ),

          // عناصر التحكم (إضافة رسالة وزر إرسال)
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _focusNode,
                          controller: _messageController,
                          maxLines: 4,
                          minLines: 1,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Add a message...",
                            hintStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.black38,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: IconButton(
                              onPressed: _toggleEmojiKeyboard,
                              icon: const Icon(Icons.emoji_emotions, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      FloatingActionButton(
                        backgroundColor: Colors.green,
                        onPressed: () => _addStatus(ref),
                        child: const Icon(Icons.send, size: 20),
                      ),
                    ],
                  ),
                ),
                if (_isShowEmoji)
                  SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        setState(() {
                          _messageController.text += emoji.emoji;
                        });
                      },
                      config: Config(
                        emojiViewConfig: EmojiViewConfig(emojiSizeMax: 32),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // حالة التحميل
          if (state.isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
