// Basic Flutter widget smoke test for I Was There app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:i_was_there/core/router/app_routes.dart';
import 'package:i_was_there/main.dart';

void main() {
  testWidgets('App loads and shows title', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.root,
      routes: [
        GoRoute(
          path: AppRoutes.root,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('I Was There')),
          ),
        ),
      ],
    );

    await tester.pumpWidget(MyApp(router: router));
    await tester.pumpAndSettle();

    expect(find.text('I Was There'), findsOneWidget);
  });
}
