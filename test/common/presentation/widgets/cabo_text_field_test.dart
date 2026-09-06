import 'package:cabo/common/presentation/widgets/cabo_text_field.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, {required bool isObscured}) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: CaboTextField(
            controller: TextEditingController(),
            label: 'Password',
            isObscured: isObscured,
          ),
        ),
      ),
    );
  }

  bool isHidden(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField)).obscureText;

  group('CaboTextField', () {
    testWidgets('offers no reveal toggle on a plain field', (
      WidgetTester tester,
    ) async {
      await pump(tester, isObscured: false);

      expect(find.byType(IconButton), findsNothing);
      expect(isHidden(tester), isFalse);
    });

    testWidgets('reveals and hides an obscured field again', (
      WidgetTester tester,
    ) async {
      await pump(tester, isObscured: true);
      expect(isHidden(tester), isTrue);

      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(isHidden(tester), isFalse);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(isHidden(tester), isTrue);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });
  });
}
