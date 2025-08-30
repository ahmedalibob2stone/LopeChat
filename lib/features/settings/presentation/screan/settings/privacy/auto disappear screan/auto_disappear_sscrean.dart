import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/privacy/auto disappear message/vm/provider.dart';
import '../../../../viewmodel/privacy/auto disappear message/auto_disappearViewModel.dart';


class AutoDisappearSettingsScreen extends ConsumerWidget {
  const AutoDisappearSettingsScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final state = ref.watch(autoDisappearViewModelProvider);
    final vm = ref.read(autoDisappearViewModelProvider.notifier);
    final options = AutoDisappearViewModel.options;
    if (state.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('موقت الرسائل التلقائي'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'بدء الدردشات الجديدة مع ضبط موقت الرسائل ذاتية الاختفاء على:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...List.generate(options.length, (index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  options[index],
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: Icon(
                  state.selectedIndex == index
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: state.selectedIndex == index ? Colors.green : Colors.grey,
                ),
                onTap: () => vm.selectOption(index),
              );
            }),
            const SizedBox(height: 24),
            Text(
              state.selectedIndex == 3
                  ? 'عند تفعيل هذا الإعداد، ستبدأ جميع الدردشات الفردية الجديدة برسائل ذاتية الاختفاء مضبوطة بحيث تختفي بعد المدة المحددة. لن يؤثر هذا الإعداد في دردشتك الحالية.'
                  : 'لا يؤثر هذا في دردشتك الحالية. استخدم موقت الرسائل هذا مع الدردشات الموجودة حالياً.',
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            if (state.errorMessage != null) ...[
              const SizedBox(height: 16),
              Text('حدث خطأ: ${state.errorMessage}', style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
