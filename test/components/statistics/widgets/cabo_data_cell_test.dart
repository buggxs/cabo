import 'package:cabo/components/statistics/widgets/cabo_data_cell.dart';
import 'package:cabo/components/statistics/widgets/round_badge.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpCell(WidgetTester tester, Round round) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(child: CaboDataCell(round: round)),
        ),
      ),
    );
  }

  group('CaboDataCell', () {
    testWidgets('bundles both badge icons', (WidgetTester tester) async {
      for (final String asset in <String>[
        'assets/images/badge_kamikaze.png',
        'assets/images/badge_precision_landing.png',
      ]) {
        final ByteData bytes = await rootBundle.load(asset);
        expect(bytes.lengthInBytes, greaterThan(0), reason: asset);
      }
    });

    testWidgets('shows the plain score without any badge', (
      WidgetTester tester,
    ) async {
      await pumpCell(tester, const Round(round: 1, points: 7));

      expect(find.text('7'), findsOneWidget);
      expect(find.byType(RoundBadge), findsNothing);
    });

    testWidgets('shows the hand points and a +5 badge on a penalty', (
      WidgetTester tester,
    ) async {
      await pumpCell(
        tester,
        const Round(
          round: 1,
          points: 12,
          hasClosedRound: true,
          hasPenaltyPoints: true,
        ),
      );

      expect(find.text('7'), findsOneWidget);
      expect(find.text('+5'), findsOneWidget);
    });

    testWidgets('badges the player who played the kamikaze', (
      WidgetTester tester,
    ) async {
      await pumpCell(
        tester,
        const Round(
          round: 1,
          points: 0,
          isKamikazeRound: true,
          isWonRound: true,
        ),
      );

      expect(find.text('KAMIKAZE'), findsOneWidget);
      expect(
        find.image(const AssetImage('assets/images/badge_kamikaze.png')),
        findsOneWidget,
      );
    });

    testWidgets('leaves the penalised players of a kamikaze unbadged', (
      WidgetTester tester,
    ) async {
      await pumpCell(
        tester,
        const Round(round: 1, points: 50, isKamikazeRound: true),
      );

      expect(find.text('50'), findsOneWidget);
      expect(find.byType(RoundBadge), findsNothing);
    });

    testWidgets('shows the actual deduction of a precision landing', (
      WidgetTester tester,
    ) async {
      await pumpCell(
        tester,
        const Round(
          round: 1,
          points: 20,
          hasPrecisionLanding: true,
          precisionLandingDeduction: 100,
        ),
      );

      expect(find.text('-100'), findsOneWidget);
      expect(
        find.image(
          const AssetImage('assets/images/badge_precision_landing.png'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('falls back to 50 for rounds stored without a deduction', (
      WidgetTester tester,
    ) async {
      await pumpCell(
        tester,
        const Round(round: 1, points: 20, hasPrecisionLanding: true),
      );

      expect(find.text('-50'), findsOneWidget);
    });

    testWidgets('shows only the landing badge on a kamikaze that lands', (
      WidgetTester tester,
    ) async {
      await pumpCell(
        tester,
        const Round(
          round: 1,
          points: 50,
          isKamikazeRound: true,
          hasPrecisionLanding: true,
          precisionLandingDeduction: 50,
        ),
      );

      expect(find.byType(RoundBadge), findsOneWidget);
      expect(find.text('-50'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
