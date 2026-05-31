import 'package:flutter_test/flutter_test.dart';
import 'package:untitled6/main.dart';

void main() {
  testWidgets('App renders layout screen successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that layout screen shows the initial screen title.
    expect(find.text('Omni-Link'), findsOneWidget);
  });
}

