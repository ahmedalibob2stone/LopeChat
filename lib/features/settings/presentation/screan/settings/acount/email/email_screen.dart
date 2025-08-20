import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../provider/account/email/viewmodel/provider.dart';
import '../../../../viewmodel/acount/email/email_viewmodel.dart';



class EditEmailScreen extends ConsumerStatefulWidget {
  const EditEmailScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditEmailScreen> createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends ConsumerState<EditEmailScreen> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    final email = ref.read(emailEditViewModelProvider).email ?? '';
    _emailController = TextEditingController(text: email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _saveEmail() {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    ref.read(emailEditViewModelProvider.notifier).saveEmail(email);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emailEditViewModelProvider);

    if (state.status == EmailEditStatus.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop(state.email);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email address'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: state.status == EmailEditStatus.loading ? null : _saveEmail,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your email address. This will not be visible to others.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: const OutlineInputBorder(),
                errorText: (state.status == EmailEditStatus.error) ? state.errorMessage : null,
              ),
              keyboardType: TextInputType.emailAddress,
              enabled: state.status != EmailEditStatus.loading,
            ),
            if (state.status == EmailEditStatus.loading)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
