import 'package:flutter/material.dart';

class EncryptionInfoScreen extends StatelessWidget {
  const EncryptionInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encryption Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'End-to-End Encryption',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Messages and calls are secured with end-to-end encryption. '
                  'This means that only you and the person you\'re communicating with '
                  'can read or listen to what is sent, and nobody in between, not even the service provider.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Tap to verify encryption keys with your contacts to ensure secure communication.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
