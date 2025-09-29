import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('App has a login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Navigating to register screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final registerButton = find.text('Register');
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    expect(find.text('Register'), findsOneWidget);
  });

  testWidgets('Home screen displays user list', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Simulate user login
    // You may need to mock the AuthProvider or set its state directly

    await tester.pumpAndSettle();

    final userListButton = find.text('Users');
    await tester.tap(userListButton);
    await tester.pumpAndSettle();

    expect(find.text('User List'), findsOneWidget);
  });
}