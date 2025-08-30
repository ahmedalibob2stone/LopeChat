import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lopechat/splash%20screan/splash_screen.dart';
import 'OnGenerateRoutes.dart';
import 'firebase_option_normal.dart';
import 'firebase_options.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/settings/presentation/provider/account/email/data/provider.dart';
import 'features/settings/presentation/provider/privacy/app lock/data/provider.dart';
import 'features/settings/presentation/screan/settings/privacy/app lock/app_lock_gate.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.environment.containsKey('FLUTTER_TEST')) {
    await dotenv.load(fileName:".env");
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptionsNormal.currentPlatform,
  );
  final sharedPreferences = await SharedPreferences.getInstance();


  final container = ProviderContainer();
  final repository = container.read(appLockRepositoryProvider);
  final isEnabled = await repository.isAppLockEnabled();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MyApp(showLock: isEnabled),
    ),
  );
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
      home:showLock ? const AppLockGate() : const SplashScreen(),
      routes: {
        '/home': (_) => const SplashScreen(),
      },
    );
    //SplashScreen
  }
}
