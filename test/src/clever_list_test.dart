import 'package:clever_list/clever_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CleverList Widget Tests', () {
    testWidgets('CleverList renders correctly', (WidgetTester tester) async {
      final items = ['item 1', 'item 2', 'item 3'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CleverList<String>(
              items: items,
              builder: (context, value) {
                return ListTile(
                  title: Text(value),
                );
              },
            ),
          ),
        ),
      );

      // Verify that the items are displayed on the screen
      expect(find.text('item 1'), findsOneWidget);
      expect(find.text('item 2'), findsOneWidget);
      expect(find.text('item 3'), findsOneWidget);
    });
  });
}
