import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../constant.dart';
import '../../../../provider/account/changenumber/viewmodel/provider.dart';

class EnterPhoneNumberScreen extends ConsumerStatefulWidget {
  const EnterPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EnterPhoneNumberScreen> createState() => _EnterPhoneNumberScreenState();
}

class _EnterPhoneNumberScreenState extends ConsumerState<EnterPhoneNumberScreen> {
  final _oldPhoneController = TextEditingController();
  final _newPhoneController = TextEditingController();
  final _codeController = TextEditingController(); // كود SMS

  @override
  void dispose() {
    _oldPhoneController.dispose();
    _newPhoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _verifyOldNumber() {
    final vm = ref.read(changeNumberViewModelProvider.notifier);

    vm.verifyOldNumber(
      phoneNumber: _oldPhoneController.text,
      onSuccess: () {
        _showSnackBar('Old number verified. Now verifying new number...');
        _verifyNewNumber();
      },
      onError: (error) => _showErrorDialog(error),
    );
  }

  void _verifyNewNumber() {
    final vm = ref.read(changeNumberViewModelProvider.notifier);

    vm.verifyNewNumber(
      phoneNumber: _newPhoneController.text,
      onSuccess: () {
        _showSnackBar('Phone number updated successfully');
        Navigator.of(context).pushNamed(PageConst.SuccessScreen);

      },
      onError: (error) => _showErrorDialog(error),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void _onNextPressed() {
    if (_oldPhoneController.text.isEmpty || _newPhoneController.text.isEmpty) {
      _showErrorDialog("Please enter both old and new phone numbers.");
    } else {
      _verifyOldNumber();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changeNumberViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Numbers"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _oldPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Enter your old phone number",
                prefixText: "+",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Enter your new phone number",
                prefixText: "+",
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            if (state.isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _onNextPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.teal,
                ),
                child: const Text("NEXT"),
              ),
          ],
        ),
      ),
    );
  }
}
