import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusRing extends StatelessWidget {
  final String imageUrl;
  final int totalStories;
  final int seenStories;

  const StatusRing({
    Key? key,
    required this.imageUrl,
    required this.totalStories,
    required this.seenStories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StatusRingPainter(
        totalStories: totalStories,
        seenStories: seenStories,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0), // مساحة للرسم
        child: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(imageUrl),
        ),
      ),
    );
  }
}

class _StatusRingPainter extends CustomPainter {
  final int totalStories;
  final int seenStories;

  _StatusRingPainter({required this.totalStories, required this.seenStories});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final sweepAngle = 2 * 3.141592653589793 / totalStories;
    final paintSeen = Paint()
      ..color = Colors.grey
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintUnseen = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < totalStories; i++) {
      final paint = i < seenStories ? paintSeen : paintUnseen;
      final startAngle = i * sweepAngle;
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle - 0.05, // مسافة صغيرة بين الخطوط
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
