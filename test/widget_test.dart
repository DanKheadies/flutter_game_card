// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_game_card/helpers/helpers.dart';
import 'package:flutter_game_card/main.dart';
import 'package:flutter_game_card/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Smoke & mirrors test', (WidgetTester tester) async {
    // Setup mock storage.
    initHydratedStorage();

    // Build our game and trigger a frame.
    await tester.pumpWidget(const CardGame());

    // Verify that the 'Play' button is shown.
    expect(find.text('Play'), findsOneWidget);

    // Verify that the 'Settings' button is shown.
    expect(find.text('Settings'), findsOneWidget);

    // Go to 'Settings'.
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Music'), findsOneWidget);

    // Go back to main menu.
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Tap 'Play'.
    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();
    expect(find.byType(PlayingCardWidget), findsWidgets);

    // Tap 'Back'.
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Verify we're back on the homepage.
    expect(find.text('Play'), findsOneWidget);
  });
}
