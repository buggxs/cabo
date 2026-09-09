import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/statistics/widgets/cabo_data_cell.dart';
import 'package:cabo/components/statistics/widgets/round_row.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpRow(WidgetTester tester, List<Round> rounds) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: RoundRow(rounds: rounds),
          ),
        ),
      ),
    );
  }

  Color? rowColor(WidgetTester tester) {
    final DecoratedBox box = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(RoundRow),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    return (box.decoration as BoxDecoration).color;
  }

  group('RoundRow', () {
    testWidgets('renders one cell per player', (WidgetTester tester) async {
      await pumpRow(tester, const <Round>[
        Round(round: 1, points: 3),
        Round(round: 1, points: 0, isWonRound: true),
        Round(round: 1, points: 7),
      ]);

      expect(find.byType(CaboDataCell), findsNWidgets(3));
      expect(rowColor(tester), isNull);
    });

    testWidgets('highlights a kamikaze round as a whole row', (
      WidgetTester tester,
    ) async {
      await pumpRow(tester, const <Round>[
        Round(round: 1, points: 50, isKamikazeRound: true),
        Round(round: 1, points: 0, isKamikazeRound: true, isWonRound: true),
        Round(round: 1, points: 50, isKamikazeRound: true),
      ]);

      expect(rowColor(tester), CaboTheme.errorContainer.withValues(alpha: 0.5));
      // Das Badge steht nur beim Kamikaze-Spieler, nicht in jeder Spalte.
      expect(find.text('KAMIKAZE'), findsOneWidget);
    });
  });
}
