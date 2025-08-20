import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../common/widgets/custom loading switch/custom_loading_switch.dart';
import '../../../../provider/privacy/calls/vm/viewmodel_provider.dart';

class PrivacyCallsScreen extends ConsumerWidget {
  const PrivacyCallsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(privacyCallsViewModelProvider);
    final viewModel = ref.read(privacyCallsViewModelProvider.notifier);

    ref.listen(privacyCallsViewModelProvider, (prev, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      } else if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!)),
        );
        viewModel.clearSuccessMessage();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("المكالمات"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("إسكات المتصلين المجهولين"),
            subtitle: const Text(
              "سيتم إسكات المكالمات الواردة من أرقام غير معروفة، ولكن سيستمر ظهور هذه المكالمات في علامة تبويب المكالمات والإشعارات.",
              style: TextStyle(color: Colors.grey),
            ),
            trailing: CustomLoadingSwitch(
              value: state.silenceUnknownCallers,
              isLoading: state.isLoading,
              onChanged: (value) async {
                await viewModel.toggleSilenceSetting(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
//