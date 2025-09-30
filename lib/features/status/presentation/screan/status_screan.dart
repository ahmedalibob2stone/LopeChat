import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:story_view/story_view.dart';
import '../../../../common/widgets/helper snackbar/helper_snackbar.dart';
import '../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../../domain/entities/status_entity.dart';
import '../provider/viewmodel/delete_status_viewmodel_provider.dart';
import '../provider/viewmodel/mark_status_as_seen_viewmodel_provider.dart';
import '../provider/viewmodel/status_interaction_viewmodel_provider.dart';
import '../viewmodel/status_interaction_viewmodel.dart';

class StatusScreen extends ConsumerStatefulWidget {
  final StatusEntity statusData;
  final bool isMyStatus;

  const StatusScreen({
    Key? key,
    required this.statusData,
    required this.isMyStatus,
  }) : super(key: key);

  @override
  ConsumerState<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends ConsumerState<StatusScreen> {
  final StoryController _controller = StoryController();
  bool _isPaused = false;
  int _currentStoryIndex = 0;

  @override
  void initState() {
    super.initState();
    if (!widget.isMyStatus) _markAllAsSeen();

    // الاستماع لرسائل الـ SnackBar من الـ VM


  }

  Future<void> _markAllAsSeen() async {
    final currentUserUid =
        ref.read(currentUserStreamProvider).asData?.value?.uid ?? '';
    for (var imageUrl in widget.statusData.photoUrls) {
      await ref.read(statusInteractionsViewModelProvider.notifier).markAsSeen(
        statusId: widget.statusData.statusId,
        imageUrl: imageUrl,
        currentUserUid: currentUserUid,
      );
    }
  }

  void _showSeenByBottomSheet() {
    final photoUrls = widget.statusData.photoUrls;
    if (photoUrls.isEmpty) return;

    final currentIndex = _currentStoryIndex.clamp(0, photoUrls.length - 1);
    final currentPhoto = photoUrls[currentIndex];
    final seenUsers = widget.statusData.seenBy[currentPhoto] ?? [];
    if (seenUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No one has seen this status yet"),
        ),
      );
      return; // لا تفتح BottomSheet فارغ

    }

    _controller.pause();
    _isPaused = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        initialChildSize: 0.5,
        builder: (context, scrollController) {
          return ListView.builder(
            controller: scrollController,
            itemCount: seenUsers.length,
            itemBuilder: (context, index) {
              final userData = seenUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userData[0]),
                ),
                title: Text(userData[1], style: const TextStyle(color: Colors.white)),
                subtitle: Text(userData[2], style: const TextStyle(color: Colors.white70)),
              );
            },
          );
        },
      ),
    ).whenComplete(() {
      _isPaused = false;
      _controller.play();
    });
  }

  void _onNextStory() {
    if (!_isPaused) _controller.next();
  }

  void _onPreviousStory() {
    if (!_isPaused) _controller.previous();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<StatusInteractionsState>(
      statusInteractionsViewModelProvider,
          (previous, next) {
        if (next.message != null && mounted) {
          // استخدم AppSnackbar هنا
          AppSnackbar.showSuccess(context, next.message!); // أو showError حسب الحالة
          // إعادة ضبط الرسالة لتجنب التكرار
          ref.read(statusInteractionsViewModelProvider.notifier).reset();
        }
      },
    );
    final deleteState = ref.watch(deleteStatusViewModelProvider); // لا تغيير هنا للحذف القديم

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          StoryView(
            storyItems: List.generate(
              widget.statusData.photoUrls.length,
                  (index) {
                final url = widget.statusData.photoUrls[index];
                final message = widget.statusData.messages.length > index
                    ? widget.statusData.messages[index]
                    : '';
                return StoryItem.pageImage(
                  url: url,
                  controller: _controller,
                  duration: const Duration(seconds: 8),
                  imageFit: BoxFit.cover,
                  caption: message.isNotEmpty
                      ? Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      backgroundColor: Colors.black45,
                    ),
                  )
                      : null,
                );
              },
            ),
            controller: _controller,
            onStoryShow: (_, index) => _currentStoryIndex = index,
            onComplete: () => Navigator.pop(context),
          ),

          // Header
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.statusData.profilePic),
                  radius: 25,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isMyStatus ? "My Status" : widget.statusData.username,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      if (!widget.isMyStatus)
                        Text(
                          widget.statusData.phoneNumber,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                    ],
                  ),
                ),

                if (widget.isMyStatus)
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.white),
                    onPressed: _showSeenByBottomSheet,
                  ),

                if (widget.isMyStatus)
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () async {
                      _isPaused = true;
                      _controller.pause();

                      final result = await showModalBottomSheet<bool>(
                        context: context,
                        backgroundColor: Colors.grey[900],
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (context) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.delete, color: Colors.red),
                                title: const Text("حذف هذه الصورة",
                                    style: TextStyle(color: Colors.white)),
                                onTap: () => Navigator.pop(context, true),
                              ),
                              ListTile(
                                leading: const Icon(Icons.close, color: Colors.white),
                                title: const Text("إلغاء",
                                    style: TextStyle(color: Colors.white)),
                                onTap: () => Navigator.pop(context, false),
                              ),
                            ],
                          ),
                        ),
                      );

                      if (!mounted) return;
                      if (result != true) {
                        _isPaused = false;
                        _controller.play();
                        return;
                      }

                      final index = _currentStoryIndex;
                      if (index >= widget.statusData.photoUrls.length) return;

                      final currentPhotoUrls = List<String>.from(widget.statusData.photoUrls); // نسخة مستقلة
                      final success = await ref
                          .read(statusInteractionsViewModelProvider.notifier)
                          .deleteStatus(
                        statusId: widget.statusData.statusId,
                        index: index,
                        photoUrls: currentPhotoUrls,
                      );

// تعديل الـ UI فقط إذا نجح الحذف
                      if (success && mounted) {
                        setState(() {
                          widget.statusData.photoUrls.removeAt(index);
                          widget.statusData.messages.removeAt(index);
                          if (_currentStoryIndex >= widget.statusData.photoUrls.length) {
                            _currentStoryIndex = widget.statusData.photoUrls.length - 1;
                          }
                        });
                      } else {
                        _isPaused = false;
                        _controller.play();
                        AppSnackbar.showError(context, "لا يمكن الحذف بدون اتصال بالإنترنت");
                      }

                    },
                  ),
              ],
            ),
          ),

          // مناطق اللمس
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: AbsorbPointer(
              absorbing: _isPaused,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(onTap: _onPreviousStory),
                  ),
                  Expanded(
                    child: GestureDetector(onTap: _onNextStory),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
