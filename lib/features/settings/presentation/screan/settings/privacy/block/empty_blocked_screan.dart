import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class EmptyBlockedListView extends StatelessWidget {
  const EmptyBlockedListView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.block, size: 80),
            const SizedBox(height: 16),
            const Text('No blocked contacts'),
            const SizedBox(height: 8),
            const Text('Tap the + icon to block contacts'),
            const SizedBox(height: 24),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            const Text(
              'Blocked contacts can’t call you.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}