import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../constant.dart';
import '../../../provider/privacy/camera effect/vm/camera_affects_viewmodel_provider.dart';
import '../../../provider/privacy/read receipts/vm/provider.dart';


import 'auto disappear screan/auth_disappear_massage_titel.dart';
import 'camera effect/camera_effects_listtile.dart';


class PrivacyScreen extends StatefulWidget {
  final String? initialSection;

  const PrivacyScreen({super.key, this.initialSection});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _readReceiptsKey = GlobalKey();

  bool _highlightReadReceipts = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialSection == 'read_receipts') {
        final context = _readReceiptsKey.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        setState(() {
          _highlightReadReceipts = true;
        });

        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _highlightReadReceipts = false;
          });
        });
      }
    });
  }


  void _scrollToReadReceipts() {
    Future.delayed(const Duration(milliseconds: 300), () {
      final context = _readReceiptsKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        setState(() {
          _highlightReadReceipts = true;
        });

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _highlightReadReceipts = false;
            });
          }
        });
      }
    });
  }

  void _showEnableBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const Text('Enable camera effects'),
    );
  }

  void _showDisableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Disable camera effects'),
        content: Text('Are you sure you want to disable camera effects?'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },

        ),
        centerTitle: false,
        title: const Text('Privacy'),

      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Who can see my personal info',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          ListTile(
            title: const Text('Last seen & online'),
            subtitle: const Text('My contacts'),
            onTap: () =>
                Navigator.of(context).pushNamed(PageConst.LastSeenAndOnlineScreen)

          ),
          ListTile(
            title: const Text('Profile photo'),
            subtitle: const Text('Everyone'),
            onTap: () =>
                Navigator.of(context).pushNamed(PageConst.ProfilePhotoPrivacyScreen)

            //ProfilePhotoScreen(),
            ),
          ListTile(
        title: const Text('About'),
        subtitle: const Text('My contacts'),
        onTap: () =>
            Navigator.of(context).pushNamed(PageConst.AboutPrivacyScreen)

      ),
      ListTile(
          title: const Text('Links'),
          subtitle: const Text('My contacts'),
          onTap: () =>
              Navigator.of(context).pushNamed(PageConst.ProfileLinksPrivacyScreen)

      ),
      ListTile(
          title: const Text('Status'),
          subtitle: const Text('My contacts'),
          onTap: () =>
              Navigator.of(context).pushNamed(PageConst.ProfileLinksPrivacyScreen)

      ),

      ListTile(
          title: const Text('Status'),
          subtitle: const Text('My contacts'),
          onTap: () =>
              Navigator.of(context).pushNamed(PageConst.StatusPrivacyScreen)

      ),
          AutoDisappearMessageTile(
            rightSideText: 'Off', // استخدم حالة حقيقية لو لديك
            onTap: () {
              Navigator.pushNamed(context, PageConst.AutoDisappearMessageTile);
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(readReceiptsViewModelProvider);
              final vm = ref.read(readReceiptsViewModelProvider.notifier);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage!)),
                  );
                  vm.clearMessages();
                }
                if (state.successMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.successMessage!)),
                  );
                  vm.clearMessages();
                }
              });

              return Container(
                key: _readReceiptsKey,
                decoration: _highlightReadReceipts
                    ? BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                )
                    : null,
                child: ListTile(
                  key: _readReceiptsKey,
                  tileColor: _highlightReadReceipts ? Colors.blue.shade100 : null,
                  title: const Text('Read Receipts'),
                  subtitle: const Text(
                    'When this setting is enabled, others will see that you’ve read their messages',
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: state.isLoading
                      ? const CircularProgressIndicator()
                      : Switch(
                    value: state.readReceiptsEnabled,
                    onChanged: (val) => vm.toggleReadReceipts(val),
                  ),
                ),
              );
            },
          ),


        ListTile(
        title: const Text('Groups'),
        subtitle: const Text('every body'),
        onTap: () => {
          Navigator.of(context).pushNamed(PageConst.GroupPrivacyScreen)
        },
      ),

          ListTile(
            title: const Text('Calls'),
            subtitle: const Text('Silence unknown callers'),
             onTap: () => Navigator.of(context).pushNamed(PageConst.PrivacyCallsScreen)
          ),
          ListTile(
            title: const Text('Blocked contacts'),
            subtitle: const Text('No body'),
            onTap: () => {
              Navigator.of(context).pushNamed(PageConst.BlockedUsersScreen)
            },
          ),

          ListTile(
            title: const Text(' Lock App'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => {
              Navigator.of(context).pushNamed(PageConst.AppLockMainScreen)
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(cameraEffectsViewModelProvider);
              final vm = ref.read(cameraEffectsViewModelProvider.notifier);

              return ListTile(
                leading: const Icon(Icons.face_retouching_natural, color: Colors.green),
                title: const Text(
                  "Camera Effects",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Enhance your camera experience with filters and stickers.",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Switch(
                  value: state.isEnabled,
                  onChanged: (value) async {
                    if (!value) {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text(
                            "Disable camera effects?",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                            "You will not be able to use effects in camera or video calls.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Disable"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(child: CircularProgressIndicator()),
                        );
                        await vm.setStatus(false);
                        if (context.mounted) Navigator.pop(context);
                      }
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CircularProgressIndicator()),
                      );
                      await vm.setStatus(true);
                      if (context.mounted) Navigator.pop(context);
                      if (context.mounted) {
                        showCameraEffectsBottomSheet(context,ref);
                      }
                    }
                  },
                ),
              );
            },
          ),


          ListTile(
            title: const Text("Advanced"),
            subtitle: const Text("Protect IP in calls and disable link previews"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
           Navigator.of(context).pushNamed(PageConst.AdvancedPrivacyScreen);

            },
          ),
          ListTile(
              title: const Text('Verify of Privacy'),
              subtitle: const Text('You can control your privacy settings '),
              onTap: () =>
                  Navigator.of(context).pushNamed(PageConst.StatusPrivacyScreen)

          ),




        ],
      ),
    );
  }
}





