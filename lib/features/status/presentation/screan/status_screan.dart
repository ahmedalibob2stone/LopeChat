import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:story_view/story_view.dart';

import '../../../../common/Provider/profile_phote_visiblity_provider.dart';
import '../../../../common/widgets/Loeading.dart';
import '../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../viewmodel/provider/delete_status_viewmodel_provider.dart';

class StatusScreen extends ConsumerStatefulWidget {
  final String username;
  final String profilePic;
  final String phoneNumber;
  final List<String> photoUrls;
  final List<String> massage;
  final String uid;

  const StatusScreen({
    Key? key,
    required this.username,
    required this.profilePic,
    required this.phoneNumber,
    required this.photoUrls,
    required this.massage,
    required this.uid,
  }) : super(key: key);

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends ConsumerState<StatusScreen> {
  final StoryController _controller = StoryController();
  late final List<StoryItem> _storyItems = [];

  void _initStoryItems() {
    _storyItems.clear();
    for (int i = 0; i < widget.photoUrls.length; i++) {
      final caption =
      widget.massage[i].isNotEmpty ? widget.massage[i] : 'Default Caption';

      _storyItems.add(
        StoryItem.pageImage(
          url: widget.photoUrls[i],
          controller: _controller,
          imageFit: BoxFit.cover,
          caption: Text(caption),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initStoryItems();
  }

  void _deleteStatus(int index) {
    ref
        .read(deleteStatusViewModelProvider.notifier)
        .deleteStatus(index, widget.photoUrls);
    setState(() {
      widget.photoUrls.removeAt(index);
      widget.massage.removeAt(index);
      _initStoryItems();
    });
  }

  void onMessageDelete(BuildContext context) {
    if (widget.uid != FirebaseAuth.instance.currentUser!.uid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                child: const Text("Delete"),
                onPressed: () {
                  _deleteStatus(0);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deleteState = ref.watch(deleteStatusViewModelProvider);
    final currentUser = ref.watch(currentUserStreamProvider).asData?.value;
    final currentUserId = currentUser?.uid;

    if (currentUserId == null) {
      return Scaffold(
        body: _storyItems.isEmpty
            ? const Loeading()
            : Stack(
          children: [
            StoryView(
              storyItems: _storyItems,
              controller: _controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Row(
                children: const [
                  CircleAvatar(
                    child: Icon(Icons.person),
                    radius: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final canViewPhotoAsync = ref.watch(profilePhotoVisibilityProvider({
      'currentUserId': currentUserId,
      'otherUserId': widget.uid,
    }));

    return canViewPhotoAsync.when(
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(
          body: Center(child: Text('Error checking profile photo visibility'))),
      data: (canViewPhoto) {
        return Scaffold(
          body: _storyItems.isEmpty
              ? const Loeading()
              : Stack(
            children: [
              StoryView(
                storyItems: _storyItems,
                controller: _controller,
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    Navigator.pop(context);
                  }
                },
              ),
              Positioned(
                top: 40,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: canViewPhoto
                          ? NetworkImage(widget.profilePic)
                          : null,
                      child: canViewPhoto
                          ? null
                          : const Icon(Icons.person),
                      radius: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.username,
                            style: TextStyle(
                              color: widget.username.isNotEmpty
                                  ? Colors.black54
                                  : Colors.transparent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.phoneNumber,
                            style: TextStyle(
                              color: widget.phoneNumber.isNotEmpty
                                  ? Colors.black54
                                  : Colors.transparent,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: deleteState.isLoading
                          ? null
                          : () => onMessageDelete(context),
                      icon: const Icon(Icons.more_vert,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
