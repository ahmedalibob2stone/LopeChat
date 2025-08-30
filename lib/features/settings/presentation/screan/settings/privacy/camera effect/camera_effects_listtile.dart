import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../provider/privacy/camera effect/vm/camera_affects_viewmodel_provider.dart';

class CameraEffectsListTile extends ConsumerWidget {
  const CameraEffectsListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cameraEffectsViewModelProvider);
    final vm = ref.read(cameraEffectsViewModelProvider.notifier);

    return ListTile(
      // احذف onTap حتى لا تفتح الـ BottomSheet عند الضغط على الـ ListTile
      leading: Icon(Icons.face_retouching_natural, color: Colors.green),
      title: Text("تأثيرات الكاميرا", style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("تحسين تجربة الكاميرا باستخدام الفلاتر والملصقات."),
      trailing: Switch(
        value: state.isEnabled,
        onChanged: (value) async {
          if (!value) {
            // تأكيد الإيقاف
            final confirm = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: Text("إيقاف تأثيرات الكاميرا؟", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                content: Text("لن تتمكن من استخدام التأثيرات في الكاميرا أو مكالمات الفيديو."),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: Text("إلغاء")),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: Text("إيقاف")),
                ],
              ),
            );

            if (confirm == true) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Center(child: CircularProgressIndicator()),
              );
              await vm.setStatus(false);
              Navigator.pop(context); // لإغلاق الـ loading
            }
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Center(child: CircularProgressIndicator()),
            );
            await vm.setStatus(true);
            Navigator.pop(context);

            showCameraEffectsBottomSheet(context,ref);

          }
        },

      ),
    );
  }
}
void showCameraEffectsBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Consumer(builder: (context, ref, _) {
        final state = ref.watch(cameraEffectsViewModelProvider);
        final vm = ref.read(cameraEffectsViewModelProvider.notifier);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.tag_faces, size: 30, color: Colors.green),
                  SizedBox(width: 10),
                  Text("استخدام تأثير الكاميرا", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.lock, size: 20, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(child: Text("تظل الرسائل ومكالماتك الشخصية مشفرة", style: TextStyle(fontSize: 14))),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(child: Text("أشعر بالخصوصية، لدينا معلومات عن كيفية استخدامك لبياناتك. يمكنك إيقاف تشغيل التأثيرات من الإعدادات لاحقًا.", style: TextStyle(fontSize: 12))),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (!state.isEnabled) {
                    // شغل الـ switch
                    await vm.setStatus(true);
                    Navigator.pop(context);
                  }
                },
                child: Text("متابعة"),
              ),
              SizedBox(height: 8),
              if (state.isEnabled)
                SwitchListTile(
                  title: Text("تشغيل تأثير الكاميرا"),
                  value: state.isEnabled,
                  onChanged: (value) async {
                    if (!value) {
                      // اظهر Dialog تأكيد الإيقاف
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("إيقاف تشغيل تأثيرات الكاميرا؟", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          content: Text("سيتعذر عليك استخدام التأثير في الكاميرا ومكالمات الفيديو", style: TextStyle(color: Colors.red)),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: Text("إلغاء")),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: Text("إيقاف التشغيل")),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await vm.setStatus(false);
                      }
                    } else {
                      await vm.setStatus(true);
                    }
                  },
                ),
              if (state.isLoading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        );
      });
    },
  );
}

