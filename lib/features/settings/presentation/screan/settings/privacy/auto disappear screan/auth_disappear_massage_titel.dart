import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutoDisappearMessageTile extends StatelessWidget {
  final String rightSideText;
  final VoidCallback onTap;

  const AutoDisappearMessageTile({
    Key? key,
    required this.rightSideText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'موقت الرسائل التلقائي',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600], // لون جري
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'موقت الرسائل التلقائي',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          // النص الأصغر أسفل الوصف
          Text(
            'ابدأ الدردشة الجديدة برسائل ذاتية الاختفاء يمكنك ضبط مده ظهورها باستخدام الموقت',
            style: TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      trailing: Text(
        rightSideText,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent, // يمكنك تعديل اللون حسب الرغبة
        ),
      ),
    );
  }
}
