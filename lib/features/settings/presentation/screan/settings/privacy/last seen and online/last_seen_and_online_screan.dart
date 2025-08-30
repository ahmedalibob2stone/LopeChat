  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';

  import '../../../../../../../common/widgets/Loeading.dart';
  import '../../../../../../../constant.dart';
  import '../../../../provider/privacy/last seen and online/vm/provider.dart';

  import '../../../../viewmodel/privacy/last seen and online/privacy_settings_viewmodel.dart';

  class LastSeenAndOnlineScreen extends ConsumerWidget {
    const LastSeenAndOnlineScreen({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final state = ref.watch(lastSeenAndOnlineViewModelProvider);
      final viewModel = ref.read(lastSeenAndOnlineViewModelProvider.notifier);

      void showSnackBar(String message) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }

      ref.listen<LastSeenAndOnlineState>(
        lastSeenAndOnlineViewModelProvider,
            (previous, next) {
          if (previous?.error != next.error && next.error != null) {
            showSnackBar(next.error!);
          }
        },
      );

      return Scaffold(

        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },

          ),
          centerTitle: false,
          title: const Text('Last Seen & Online'),


        ),

        body: state.isLoading
            ? const Center(child: Loeading())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Who can see my last seen?'),
            ..._buildOptions(
              context: context,
              currentValue: state.privacySettings?.lastSeenVisibility,
              onSelect: (val) async {
                await viewModel.setLastSeenVisibility(val);
                if (ref.read(lastSeenAndOnlineViewModelProvider).error == null) {
                  showSnackBar("Updated successfully");
                }
              },
              onExceptTap: () {

                Navigator.of(context).pushNamed(PageConst.ExcludedContactsLastSeenAndOnlineScreen);

              },
              saving: state.isSaving,
            ),
            const Divider(),
            _buildSectionTitle("Who can see when I'm online?"),
            ..._buildOptions(
              context: context,
              currentValue: state.privacySettings?.onlineVisibility,
              onSelect: (val) async {
                await viewModel.setOnlineVisibility(val);
                if (ref.read(lastSeenAndOnlineViewModelProvider).error == null) {
                  showSnackBar("Updated successfully");
                }
              },
              onExceptTap: null,
              saving: state.isSaving,
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "If you don't share your Last Seen or Online status, you won't be able to see others' Last Seen or Online either.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildSectionTitle(String title) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );

    List<Widget> _buildOptions({
      required BuildContext context,
      required String? currentValue,
      required Function(String) onSelect,
      required bool saving,
      Function()? onExceptTap,
    }) {
      final options = <Map<String, String>>[
        {'label': 'Everyone', 'value': LastSeenAndOnlinePrivacyVisibility.everyone},
        {'label': 'My Contacts', 'value': LastSeenAndOnlinePrivacyVisibility.myContacts},
        {'label': 'My Contacts Except...', 'value': LastSeenAndOnlinePrivacyVisibility.myContactsExcept},
        {'label': 'Nobody', 'value': LastSeenAndOnlinePrivacyVisibility.nobody},
      ];


      return options.map((opt) {
        final isSelected = currentValue == opt['value'];
        return ListTile(
          onTap: () {
            final value = opt['value']!;
            if (value == 'my_contacts_except' && onExceptTap != null) {
              onExceptTap();
            } else {
              onSelect(value);
            }
          },
          title: Text(opt['label']!),
          trailing: saving && isSelected
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected ? Colors.green : null,
          ),
        );
      }).toList();
    }
  }
