import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../constant.dart';
import '../../../../../../user/presentation/provider/stream_provider/get_user_data_by_id_stream_provider.dart';
import '../../../../../../user/presentation/provider/stream_provider/stream_providers.dart';
import '../../../../provider/account/account manage/vm/provider.dart';


class AddAccountBottomSheet extends ConsumerWidget {
  const AddAccountBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserStreamProvider );
    final accountsAsync = ref.watch(accountManagerViewModelProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'معلومات الحساب الحالي',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(currentUser!.profile),
              ),
              const SizedBox(height: 10),
              Text(currentUser.name, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              Text(currentUser.phoneNumber, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, PageConst.AddAccountScreen);

                },
                icon: const Icon(Icons.add),
                label: const Text("إضافة حساب"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),

              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              // عنوان قائمة الحسابات الأخرى
              const Text(
                'الحسابات الأخرى',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: accountsAsync.when(
                  data: (accounts) {
                    if (accounts.isEmpty) {
                      return const Center(child: Text('لا توجد حسابات أخرى'));
                    }
                    return ListView.builder(
                      itemCount: accounts.length,
                      itemBuilder: (context, index) {
                        final user = accounts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.profile),
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.phoneNumber),
                          onTap: () async {
                            await ref.read(accountManagerViewModelProvider.notifier).switchAccount(user.uid);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('حدث خطأ: $e')),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('حدث خطأ: $e')),
    );
  }
}
