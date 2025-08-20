import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../contact/presentation/provider/vm/get_all_app_contact_viewmodel_provider.dart.dart';
import '../../../../../../contact/presentation/view/select_contact_screan.dart';
import '../../../../provider/privacy/links/vm/provider.dart';


class ProfileLinksPrivacyScreen extends ConsumerStatefulWidget {
  const ProfileLinksPrivacyScreen({super.key});

  @override
  ConsumerState<ProfileLinksPrivacyScreen> createState() =>
      _ProfileLinksPrivacyScreenState();
}

class _ProfileLinksPrivacyScreenState
    extends ConsumerState<ProfileLinksPrivacyScreen> {
  String _selectedOption = 'everyone';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(linksPrivacyViewModelProvider);

      if (state.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message!)),
        );
        ref.read(linksPrivacyViewModelProvider.notifier).clearMessages();
      }

      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
        );
        ref.read(linksPrivacyViewModelProvider.notifier).clearMessages();
      }
    });
    Future.microtask(() => ref.read(linksPrivacyViewModelProvider.notifier).loadLinksPrivacy());
  }

  Future<void> _onOptionSelected(String value) async {
    // تحديث الاختيار محلياً فوراً للـ UI
    setState(() {
      _selectedOption = value;
    });

    final notifier = ref.read(linksPrivacyViewModelProvider.notifier);

    if (value == 'contacts_except') {
      final allContactsNested = await ref.read(contactsControllerProvider.notifier).getAllContactUseCase();
      final allContacts = allContactsNested.expand((list) => list).toList();


        final selectedUids = await Navigator.push<List<String>>(
          context,
          MaterialPageRoute(
            builder: (_) => SelectContactsScreen(
              initiallySelected: notifier.state.exceptUids, appContacts: allContacts, nonAppContacts: [],
            ),
          ),
        );

        if (selectedUids != null) {
          await notifier.updateLinksPrivacy(value, selectedUids);

        }

    } else {
      await notifier.updateLinksPrivacy(value);

    }
  }

  Widget _buildOption(String label, String value) {
    return GestureDetector(
      onTap: () => _onOptionSelected(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: _selectedOption == value ? Colors.green.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
            if (_selectedOption == value)
              const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(linksPrivacyViewModelProvider);
    _selectedOption = state.visibility; // خذ القيمة من الحالة

    return Scaffold(
      appBar: AppBar(
        title: const Text('من يمكنه رؤية الروابط'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOption('الكل', 'everyone'),
            _buildOption('جهات اتصالي', 'my_contacts'),
            _buildOption('جهات اتصالي باستثناء...', 'contacts_except'),
            _buildOption('لا أحد', 'nobody'),
          ],
        ),
      ),
    );
  }
}
