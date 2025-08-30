

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../responsive/mobile_screen_Layout.dart';
import '../../../responsive/responsive.dart';
import '../../../responsive/web_screen_Layout.dart';
import '../../welcome/screans/landing_screan.dart';
import '../provider/ckeck_user_provider.dart';


class CheckUserScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkUserViewModelProvider);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (!state.isSuccess || state.user == null) {
      return const Welcome_Screan();
    } else {
      return MobileScreenLayout(

      );
    }
  }
}

