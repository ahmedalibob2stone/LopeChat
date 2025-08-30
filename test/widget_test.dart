
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lopechat/main.dart';

void main() {
  testWidgets('SplashScreen يظهر لما showLock=false', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(showLock: false));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('AppLockGate يظهر لما showLock=true', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(showLock: true),
      ),
    );

    // ما تستخدم pumpAndSettle
    expect(find.byIcon(Icons.lock), findsOneWidget);
  });


}
