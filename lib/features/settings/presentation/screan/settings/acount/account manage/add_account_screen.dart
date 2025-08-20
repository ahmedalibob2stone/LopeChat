import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../constant.dart';
import '../../../../../../user/domain/entities/user_entity.dart';
import '../../../../../../user/domain/usecases/provider/usecase/provider.dart';



class AddAccountScreen extends ConsumerWidget {
  const AddAccountScreen({super.key});

  Future<void> _onAddAccountPressed(BuildContext context) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = connectivityResult != ConnectivityResult.none;

    if (!hasInternet) {
      _showErrorDialog(context);
      return;
    }

    Navigator.pushNamed(
      context,
      PageConst.LoginScrean,
      arguments: {
        'isFromAddAccount': true,
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("No Internet"),
        content: const Text(
          "Couldn’t switch accounts. Please check your connection and try again.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);

    return FutureBuilder<UserEntity?>(
      future: getCurrentUserUseCase.call(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('No current user data found.')),
          );
        }

        final user = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Add account"),
            backgroundColor: Colors.teal,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Your current account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                CircleAvatar(
                  radius: 45,
                  backgroundImage: user.profile != null && user.profile!.isNotEmpty
                      ? NetworkImage(user.profile!)
                      : null,
                  child: (user.profile == null || user.profile!.isEmpty)
                      ? const Icon(Icons.person, size: 45)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.name ?? 'No Name',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  user.phoneNumber ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                const Text(
                  "To add a new WhatsApp account, you'll need to sign in with another number. This won’t affect your current account.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _onAddAccountPressed(context),
                  icon: const Icon(Icons.add),
                  label: const Text("ADD ACCOUNT"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
