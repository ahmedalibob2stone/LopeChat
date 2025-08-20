import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../provider/privacy/advanced/vm/advanced_privacy_viewmodel_provider.dart';
import '../../../../viewmodel/privacy/advanced/advanced_privacy_viewmodel.dart';

class AdvancedPrivacyScreen extends ConsumerStatefulWidget {
  const AdvancedPrivacyScreen({super.key});

  @override
  ConsumerState<AdvancedPrivacyScreen> createState() => _AdvancedPrivacyScreenState();
}

class _AdvancedPrivacyScreenState extends ConsumerState<AdvancedPrivacyScreen> {
  @override
  void initState() {
    super.initState();
    final notifier = ref.read(advancedPrivacyViewModelProvider.notifier);
    notifier.loadBlockUnknownMessages();
    notifier.loadIpProtection();
    notifier.loadDisableLinkPreview();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(advancedPrivacyViewModelProvider);
    final vm = ref.read(advancedPrivacyViewModelProvider.notifier);

    ref.listen<AdvancedPrivacyState>(advancedPrivacyViewModelProvider, (prev, next) {
      if (next.error != null && next.error!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
        vm.clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Privacy'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text(
              "Block messages from unknown senders",
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              "To protect your account and improve performance, your app will block messages from unknown accounts when they exceed a certain threshold.",
              style: TextStyle(color: Colors.grey),
            ),
            value: state.blockUnknownMessages,
            onChanged: (val) {
              vm.toggleBlockUnknownMessages(val);
            },
          ),
          const Divider(),

          SwitchListTile(
            title: const Text(
              "Protect IP address during calls",
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              "To make it harder to determine your location, calls from this device will be relayed through app servers securely. This may slightly reduce call quality.",
              style: TextStyle(color: Colors.grey),
            ),
            value: state.ipProtection,
            onChanged: (val) {
              vm.toggleIpProtection(val);
            },
          ),
          const Divider(),

          SwitchListTile(
            title: const Text(
              "Disable link previews",
              style: TextStyle(color: Colors.black),
            ),
            subtitle: const Text(
              "To protect your IP address from being inferred by external src, previews of links you share in chats will be disabled.",
              style: TextStyle(color: Colors.grey),
            ),
            value: state.disableLinkPreview,
            onChanged: (val) {
              vm.toggleDisableLinkPreview(val);
            },
          ),
        ],
      ),
    );
  }
}
