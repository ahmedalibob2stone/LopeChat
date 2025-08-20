import 'package:flutter/material.dart';

import '../../../../../../../constant.dart';

class ChangeNumberInfoScreen extends StatelessWidget {
  const ChangeNumberInfoScreen({Key? key}) : super(key: key);

  void _navigateToPhoneInput(BuildContext context) {
    Navigator.of(context).pushNamed(PageConst.EnterPhoneNumberScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Number'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.sim_card, size: 30, color: Colors.teal),
                SizedBox(width: 10),
                Icon(Icons.more_horiz, color: Colors.teal),
                SizedBox(width: 10),
                Icon(Icons.sim_card_alert, size: 30, color: Colors.teal),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Change your phone number',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Changing your phone number will migrate your account info, groups & settings.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _navigateToPhoneInput(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.teal,
              ),
              child: const Text('NEXT'),
            )
          ],
        ),
      ),
    );
  }
}
