import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/privacy/group/vm/viewmodel_provider.dart';
import 'excluded_contact_screan.dart';
import '../../../../viewmodel/privacy/group/group_privacy_viewmodel.dart';

class GroupPrivacyScreen extends ConsumerWidget {
  const GroupPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(groupPrivacyViewModelProvider);
    final viewModel = ref.read(groupPrivacyViewModelProvider.notifier);

    void _handleVisibilitySelection(String visibility) async {
      await viewModel.setVisibility(visibility);

      if (!context.mounted) return;

      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!)),
        );
        return;
      }

      if (visibility == GroupPrivacyOptions.myContactsExcept) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ExcludedContactsScreen()),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Group Privacy")),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: GroupPrivacyOptions.labels.entries.map((entry) {
          final key = entry.key;
          final label = entry.value;
          final isSelected = state.selectedVisibility == key;

          return InkWell(
            onTap: () => _handleVisibilitySelection(key),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                title: Text(label),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
