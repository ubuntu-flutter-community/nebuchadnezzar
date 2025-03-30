import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nebuchadnezzar/app/view/app.dart';

void main() {
  testWidgets('Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const App(
        themeMode: ThemeMode.system,
        child: Text(''),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
