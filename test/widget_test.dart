import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:count_and_short/main.dart'; // Import widget utama Anda

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Buat instance database
    // Build our app and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: MyApp(), // Tambahkan parameter database
      ),
    );

    // Verify that our counter starts at 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
