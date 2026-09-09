import 'package:cabo/components/about/widgets/donation_card.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/donation/donation_service.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'donation_card_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[MockSpec<DonationService>()])
void main() {
  late MockDonationService donationService;

  setUp(() {
    donationService = MockDonationService();
    app.allowReassignment = true;
    app.registerSingleton<DonationService>(donationService);
    when(donationService.openPaypal()).thenAnswer((_) async => true);
    when(donationService.openBuyMeACoffee()).thenAnswer((_) async => true);
  });

  tearDown(() => app.reset());

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const Scaffold(body: DonationCard()),
      ),
    );
    await tester.pump();
  }

  group('DonationCard', () {
    testWidgets('shows both donation buttons', (WidgetTester tester) async {
      await pump(tester);

      expect(find.text('Say thanks with PayPal'), findsOneWidget);
      expect(find.text('Buy me a coffee'), findsOneWidget);
    });

    testWidgets('opens the PayPal link on tap', (WidgetTester tester) async {
      await pump(tester);

      await tester.tap(find.text('Say thanks with PayPal'));
      await tester.pumpAndSettle();

      verify(donationService.openPaypal()).called(1);
    });

    testWidgets('opens the Buy Me a Coffee link on tap', (
      WidgetTester tester,
    ) async {
      await pump(tester);

      await tester.tap(find.text('Buy me a coffee'));
      await tester.pumpAndSettle();

      verify(donationService.openBuyMeACoffee()).called(1);
    });

    testWidgets('shows an error message when the link cannot be opened', (
      WidgetTester tester,
    ) async {
      when(donationService.openPaypal()).thenAnswer((_) async => false);

      await pump(tester);

      await tester.tap(find.text('Say thanks with PayPal'));
      await tester.pumpAndSettle();

      expect(find.text('The link could not be opened.'), findsOneWidget);
    });
  });
}
