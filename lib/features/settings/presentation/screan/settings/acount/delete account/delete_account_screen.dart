import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../../../../constant.dart';
import '../../../../provider/account/delet account/vm/provider.dart';
import '../change number/change_number_info_screan.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  String? selectedCountryCode = '+20'; // مثال: مصر
  final phoneController = TextEditingController();

  final countries = [
    {'name': 'مصر', 'code': '+20'},
    {'name': 'السعودية', 'code': '+966'},
    {'name': 'الإمارات', 'code': '+971'},
    // أضف المزيد حسب الحاجة
  ];

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> onDeleteAccount() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = connectivityResult != ConnectivityResult.none;

    if (!hasInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يوجد اتصال بالإنترنت. الرجاء التحقق من الاتصال.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقم الهاتف')),
      );
      return;
    }

    final fullPhone = '${selectedCountryCode!}$phone';

    // استدعاء الحذف من الـ ViewModel
    await ref.read(deleteAccountViewModelProvider.notifier).deleteAccount(fullPhone);
  //  await ref.read(accountManagerViewModelProvider.notifier).onDeleteAccount(fullPhone);
    final state = ref.read(deleteAccountViewModelProvider);
    if (state.isLoading) {
      return;
    } else if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    } else if (state.isDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف الحساب بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        PageConst.LoginScrean,
            (Route<dynamic> route) => false,
      );

    }
  }
  void onChangeNumber() {
      Navigator.pushNamed(context, PageConst.ChangeNumberInfoScreen);

  }

  @override
  Widget build(BuildContext context) {
    final deleteState = ref.watch(deleteAccountViewModelProvider);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('حذف هذا الحساب'),
            backgroundColor: Colors.teal,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // التحذير الأحمر
                Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'تحذير! عند حذف الحساب:',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // النقاط الأربعة
                const Text('• سيتم حذف هذا الحساب من واتس وجميع أجهزتك.', style: TextStyle(fontSize: 14)),
                const Text('• سيتم مسح سجل الرسائل.', style: TextStyle(fontSize: 14)),
                const Text('• سيتم إزالتك من جميع المجموعات.', style: TextStyle(fontSize: 14)),
                const Text('• سيتم حذف أي قنوات أنشأتها.', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 16),

                // خط رمادي
                const Divider(thickness: 1, color: Colors.grey),

                const SizedBox(height: 8),

                // قسم تغيير الرقم
                GestureDetector(
                  onTap: onChangeNumber,
                  child: Row(
                    children: [
                      const Icon(Icons.phone_android, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'هل ترغب في تغيير الرقم بدلاً من ذلك؟',
                          style: TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // زر تغيير الرقم الأخضر
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onChangeNumber,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('تغيير الرقم', style: TextStyle(fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(thickness: 1, color: Colors.grey),
                const SizedBox(height: 16),

                // نص تأكيد حذف الحساب
                const Text(
                  'لحذف حسابك، الرجاء تأكيد رمز دولتك ورقم هاتفك:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),

                // اختيار الدولة + رقم الهاتف
                Row(
                  children: [
                    // Dropdown لاختيار الدولة
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedCountryCode,
                        underline: const SizedBox(),
                        onChanged: (val) {
                          setState(() {
                            selectedCountryCode = val;
                          });
                        },
                        items: countries
                            .map((c) => DropdownMenuItem<String>(
                          value: c['code'],
                          child: Text('${c['name']} (${c['code']})'),
                        ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // TextField لرقم الهاتف
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'رقم الهاتف',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // زر حذف الحساب الأحمر
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onDeleteAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('حذف الحساب', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Loading overlay
        if (deleteState.isLoading)
          Container(
            color: Colors.black45,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
