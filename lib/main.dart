import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lopechat/splash%20screan/splash_screen.dart';
import 'OnGenerateRoutes.dart';
import 'features/auth/domain/usecase/sign_in_with_token_usecase.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

import 'features/settings/presentation/provider/privacy/app lock/data/provider.dart';
import 'features/settings/presentation/screan/settings/privacy/app lock/app_lock_gate.dart';
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // سيتم تهيئته لاحقًا عند override في main
});
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!Platform.environment.containsKey('FLUTTER_TEST')) {
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyAppWrapper(),
    ),
  );

}

// ملف منفصل أو داخل نفس main.dart
class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم ConsumerWidget أو FutureBuilder للحصول على showLock
    return Consumer(
      builder: (context, ref, _) {
        final repository = ref.read(appLockRepositoryProvider);

        return FutureBuilder<bool>(
          future: repository.isAppLockEnabled(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const MaterialApp(
                home: Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            final showLock = snapshot.data!;

            return MyApp(showLock: showLock);
          },
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  final bool showLock;

  const MyApp({super.key, required this.showLock});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: OnGenerateRoutes.route,
      home: showLock ? const AppLockGate() : const SplashScreen(),
      routes: {
        '/home': (_) => const SplashScreen(),
      },
    );
  }
}
