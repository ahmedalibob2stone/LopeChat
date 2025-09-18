

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../responsive/mobile_screen_Layout.dart';

import '../../../welcome/screans/landing_screan.dart';
import '../provider/user_provider.dart';
import '../provider/vm/ckeck_user_provider.dart';
import '../viewmodel/ckeck_user_viewmodel.dart';

class CheckUserScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<CheckUserState>(checkUserViewModelProvider, (previous, next) {
      if (next.isSuccess && next.user != null) {
        ref.read(cachedCurrentUserProvider.notifier).state = next.user;
      }
    });

    final state = ref.watch(checkUserViewModelProvider);
    print('CheckUserState: isLoading=${state.isLoading}, isSuccess=${state.isSuccess}, user=${state.user}');


    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (!state.isSuccess || state.user == null) {
      return const Welcome_Screan();
    } else {
      return const MobileScreenLayout();
    }

  }
}
