import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// import the widget to test

// import 'package:disaster_relief_aid_flutter/App.dart';

void main() {
  testWidgets("template test", (WidgetTester tester) async {
    // await tester.pumpWidget(const MyApp());
    // await tester.tap(find.byIcon(Icons.add));

    expect(true, true);
  });
}

/*
testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  // Build our app and trigger a frame.
  await tester.pumpWidget(const MyApp());

  // Verify that our counter starts at 0.
  expect(find.text('0'), findsOneWidget);
  expect(find.text('1'), findsNothing);

  // Tap the '+' icon and trigger a frame.
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  // Verify that our counter has incremented.
  expect(find.text('0'), findsNothing);
  expect(find.text('1'), findsOneWidget);
});
*/
