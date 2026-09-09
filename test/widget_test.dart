import 'package:flutter_test/flutter_test.dart';
import 'package:kindergarten_app/core/constants/app_strings.dart';
import 'package:kindergarten_app/main.dart';

void main() {
  testWidgets('Kindergarten app smoke test and splash screen rendering', (WidgetTester tester) async {
    // Build our app and trigger initial frame.
    await tester.pumpWidget(const KindergartenApp());

    // Verify that the app brand name is rendered on Splash
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.appSubtitle), findsOneWidget);

    // Let the splash timer and transition finish
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    // Verify transition to Login screen
    expect(find.text(AppStrings.welcomeBack), findsOneWidget);
  });
}
