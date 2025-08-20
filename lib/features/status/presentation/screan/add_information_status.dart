import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant.dart';
import '../viewmodel/provider/upload_status_viewmodel_provider.dart';

class AddInformationStatus extends ConsumerStatefulWidget {
  final File file;

  const AddInformationStatus({required this.file, Key? key}) : super(key: key);

  @override
  _AddMessageForStatusState createState() => _AddMessageForStatusState();
}

class _AddMessageForStatusState extends ConsumerState<AddInformationStatus> {
  final TextEditingController _messageController = TextEditingController();
  bool _isShowEmoji = false;
  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleEmojiKeyboard() {
    if (_isShowEmoji) {
      _showKeyboard();
      _hideEmoji();
    } else {
      _hideKeyboard();
      _showEmoji();
    }
  }

  void _hideEmoji() {
    setState(() {
      _isShowEmoji = false;
    });
  }

  void _showEmoji() {
    setState(() {
      _isShowEmoji = true;
    });
  }

  void _showKeyboard() => _focusNode.requestFocus();
  void _hideKeyboard() => _focusNode.unfocus();

  void _addStatus(WidgetRef ref) {
    ref.read(uploadStatusViewModelProvider.notifier).uploadStatus(
      file: widget.file,
      message: _messageController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(uploadStatusViewModelProvider);

    return Scaffold(
      body: Stack(
        children: [
          if (state.isLoading)
            const Center(child: CircularProgressIndicator()),

          if (state.error != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ أثناء رفع الحالة.\n${state.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

          if (state.success)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 50),
                  const SizedBox(height: 16),
                  const Text(
                    'تم رفع الحالة بنجاح!',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(uploadStatusViewModelProvider.notifier).resetState();
                      Navigator.pop(context);
                    },
                    child: const Text('العودة'),
                  ),
                ],
              ),
            ),

          if (!state.isLoading && !state.success)
            Center(
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Image.file(widget.file),
              ),
            ),

          if (!state.isLoading && !state.success)
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _focusNode,
                          controller: _messageController,
                          maxLines: 4,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: "أضف رسالة...",
                            hintStyle: const TextStyle(color: Colors.black54),
                            filled: true,
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: IconButton(
                              onPressed: _toggleEmojiKeyboard,
                              icon: Icon(Icons.emoji_emotions, color: kkPrimaryColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      FloatingActionButton(
                        backgroundColor: kkPrimaryColor,
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
        ],
      ),
    );
  }
}
