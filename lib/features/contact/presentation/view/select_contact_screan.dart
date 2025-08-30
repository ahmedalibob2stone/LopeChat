import 'package:flutter/material.dart';
import '../../../user/domain/entities/user_entity.dart';

class SelectContactsScreen extends StatefulWidget {
  final List<UserEntity> appContacts;     // جهات الاتصال التي تملك التطبيق
  final List<UserEntity> nonAppContacts;  // جهات الاتصال التي لا تملك التطبيق
  final List<String> initiallySelected;

  const SelectContactsScreen({
    super.key,
    required this.appContacts,
    required this.nonAppContacts,
    this.initiallySelected = const [],
  });

  @override
  State<SelectContactsScreen> createState() => _SelectContactsScreenState();
}

class _SelectContactsScreenState extends State<SelectContactsScreen> {
  late Set<String> selectedUids;

  @override
  void initState() {
    super.initState();
    selectedUids = widget.initiallySelected.toSet();
  }

  void toggleSelection(String uid) {
    setState(() {
      if (selectedUids.contains(uid)) {
        selectedUids.remove(uid);
      } else {
        selectedUids.add(uid);
      }
    });
  }

  void submitSelection() {
    Navigator.pop(context, selectedUids.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر جهات الاتصال للاستثناء'),
        actions: [
          TextButton(
            onPressed: submitSelection,
            child: const Text('تم', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView(
        children: [
          if (widget.appContacts.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'جهات الاتصال على واتساب',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...widget.appContacts.map((user) {
              final isSelected = selectedUids.contains(user.uid);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (_) => toggleSelection(user.uid),
                title: Text(user.name),
                subtitle: Text(user.phoneNumber ?? ''),
                secondary: CircleAvatar(
                  backgroundImage:
                  user.profile.isNotEmpty ? NetworkImage(user.profile) : null,
                  child: user.profile.isEmpty ? const Icon(Icons.person) : null,
                ),
              );
            }).toList(),
          ],

          if (widget.nonAppContacts.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'دعوة جهات الاتصال',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...widget.nonAppContacts.map((user) {
              final isSelected = selectedUids.contains(user.uid);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (_) => toggleSelection(user.uid),
                title: Text(user.name),
                subtitle: Text(user.phoneNumber ?? ''),
                secondary: CircleAvatar(
                  backgroundImage:
                  user.profile.isNotEmpty ? NetworkImage(user.profile) : null,
                  child: user.profile.isEmpty ? const Icon(Icons.person) : null,
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }
}
