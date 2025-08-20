import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../contact/presentation/provider/vm/get_all_app_contact_viewmodel_provider.dart.dart';
import '../../../../../../contact/presentation/view/select_contact_screan.dart';
import '../../../../provider/privacy/about/vm/provider.dart';


class AboutPrivacyScreen extends ConsumerStatefulWidget {
  const AboutPrivacyScreen({super.key});

  @override
  ConsumerState<AboutPrivacyScreen> createState() => _AboutPrivacyScreenState();
}

class _AboutPrivacyScreenState extends ConsumerState<AboutPrivacyScreen> {
  // لا نخزن حالة هنا، نقرأها من ViewModel

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aboutPrivacyViewModelProvider);
    final vm = ref.read(aboutPrivacyViewModelProvider.notifier);

    void onOptionChanged(String? value) async {
      if (value == null) return;

      final vm = ref.read(aboutPrivacyViewModelProvider.notifier);

      if (value == 'contacts_except') {
final allContactsNested = await ref.read(contactsControllerProvider.notifier).getAllContactUseCase();
               final allContacts = allContactsNested.expand((list) => list).toList();

        final selectedUids = await Navigator.push<List<String>>(
          context,
          MaterialPageRoute(
            builder: (_) => SelectContactsScreen(

              initiallySelected: vm.state.exceptUids, appContacts: allContacts,
              nonAppContacts: [],
            ),
          ),
        );

        if (selectedUids != null) {
          vm.setExceptUids(selectedUids);
        }
      }

      vm.setVisibility(value);
    }


    void onSave() async {
      await vm.saveSettings();

      if (mounted) {
        final currentState = ref.read(aboutPrivacyViewModelProvider);
        if (currentState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(currentState.errorMessage!)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث الخصوصية')),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("من يمكنه رؤية 'حول'")),
      body: Column(
        children: [
          RadioListTile<String>(
            title: const Text("الكل"),
            value: 'everyone',
            groupValue: state.visibility,
            onChanged: onOptionChanged,
          ),
          RadioListTile<String>(
            title: const Text("جهات اتصالي"),
            value: 'contacts',
            groupValue: state.visibility,
            onChanged: onOptionChanged,
          ),
          RadioListTile<String>(
            title: const Text("جهات اتصالي باستثناء..."),
            value: 'contacts_except',
            groupValue: state.visibility,
            onChanged: onOptionChanged,
            subtitle: state.visibility == 'contacts_except' && state.exceptUids.isNotEmpty
                ? Text('تم اختيار ${state.exceptUids.length} جهة')
                : null,
          ),
          RadioListTile<String>(
            title: const Text("لا أحد"),
            value: 'nobody',
            groupValue: state.visibility,
            onChanged: onOptionChanged,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: state.isLoading ? null : onSave,
              child: state.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("حفظ"),
            ),
          ),
        ],
      ),
    );
  }
}
