// features/user/presentation/manager/user_lifecycle_manager.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/user_state_provider.dart';

class UserLifecycleManager with WidgetsBindingObserver {
  final WidgetRef ref;

  UserLifecycleManager(this.ref);

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  void handleAppLifecycle(AppLifecycleState state) {
    final viewModel = ref.read(userStateViewModelProvider.notifier);
    switch (state) {
      case AppLifecycleState.resumed:
        viewModel.setUserState('online');
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        viewModel.setUserState('offline');
        break;
      default:
    }
  }
}
