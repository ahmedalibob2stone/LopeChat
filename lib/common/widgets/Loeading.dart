import 'package:flutter/material.dart';

class Loeading extends StatelessWidget {
  const Loeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final indicatorSize = screenWidth * 0.1;

    return Center(
      child: SizedBox(
        width: indicatorSize,
        height: indicatorSize,
        child: const CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }
}
