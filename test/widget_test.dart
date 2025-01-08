import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nebuchadnezzar/app/view/app.dart';

void main() {
  testWidgets('Test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
