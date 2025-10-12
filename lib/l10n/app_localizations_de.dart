// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get gameName => 'CABO';

  @override
  String get gameSubTitle => 'Bord';

  @override
  String get menuEntryTrackStats => 'Spiel starten';

  @override
  String get menuEntryGameHistory => 'Spielhistorie';

  @override
  String get menuEntryJoinGame => 'Spiel beitreten';

  @override
  String get menuEntryGameRules => 'Spielregeln';

  @override
  String get menuEntryGameAboutScreen => 'Über die App';

  @override
  String get playerAmountDialogTitle => 'Spieler Anzahl';

  @override
  String get continueText => 'Weiter';

  @override
  String get loadedOwnRules => 'Eigene Regeln geladen.';

  @override
  String get playerNames => 'Spieler Namen';

  @override
  String get start => 'Starten';

  @override
  String get dialogPointsLabel => 'Punkte';

  @override
  String get statsCardRound => 'Runde';

  @override
  String get statsCardTime => 'Spielzeit';

  @override
  String get finishCurrentGame => 'Möchtest du das Spiel wirklich beenden?';

  @override
  String get finishGameDialogButton => 'Ja, beenden!';

  @override
  String get leaveGameDialogButton => 'Spiel verlassen.';

  @override
  String get continueGameDialogButton => 'Nein, weiter spielen.';

  @override
  String get dialogTextRoundFinishedBy => 'Wer hat die Runde beendet?';

  @override
  String get dialogTitleLoadFinishedGame => 'Nicht beendetes Spiel';

  @override
  String get dialogTextLoadFinishedGame =>
      'Du hast das letzt Spiel nicht beendet, soll es geladen werden?';

  @override
  String get loadGameDialogButton => 'Ja Spiel laden!';

  @override
  String get notLoadGameDialogButton => 'Nein, nicht laden.';

  @override
  String get enterDialogButton => 'Eintragen';

  @override
  String get enterPointsDialogTitle => 'Enter points';

  @override
  String get publishDialogTitle => 'Spiel veröffentlichen';

  @override
  String get publishDialogReadyToPublish =>
      'Dein Spiel ist bereit, veröffentlicht zu werden.';

  @override
  String get publishDialogLoading => 'Dein Spiel wird veröffentlicht...';

  @override
  String get publishDialogGamePublished => 'Dein Spiel ist jetzt öffentlich';

  @override
  String get publishDialogJoinedGame => 'Dein Spiel in einem öffentlich Spiel';

  @override
  String get publishDialogFriendsCanJoin =>
      'Andere können dem Spiel mit diesem QR Code beitreten:';

  @override
  String get publishDialogPublish => 'Spiel veröffentlichen';

  @override
  String get publishDialogFailedToPublish =>
      'Spiel konnte nicht veröffentlicht werden.';

  @override
  String get authScreenSignInToPublish =>
      'Melde dich an, um dein Spiel zu veröffentlichen.';

  @override
  String get authScreenSignInWithGoogle => 'Mit Google anmelden';

  @override
  String get authScreenSignInWithEmail => 'Mit E-Mail anmelden/registrieren';

  @override
  String get authScreenEmail => 'E-Mail';

  @override
  String get authScreenPassword => 'Passwort';

  @override
  String get authScreenPasswordRepeat => 'Passwort bestätigen';

  @override
  String get authScreenSignIn => 'Anmelden';

  @override
  String get authScreenAlreadyAccount => 'Bereits einen Account? Anmelden';

  @override
  String get authScreenRegister => 'Registrieren';

  @override
  String get authScreenPasswortMissmatch => 'Passwörter stimmen nicht überein.';

  @override
  String get authScreenStartRegister => 'Noch keinen Account? Registrieren';

  @override
  String get authScreenBack => 'Zurück';

  @override
  String get joinGameScreenScanToJoin =>
      'Scanne einen QR-Code, um einem Spiel beizutreten.';

  @override
  String get joinGameScreenGameFound => 'Spiel gefunden!';

  @override
  String get joinGameScreenGameRounds => 'Runden';

  @override
  String get joinGameScreenGamePoints => 'Punkte';

  @override
  String get joinGameScreenLoadingStatus => 'Es wurde eine Spiel-ID erkannt';

  @override
  String get joinGameScreenSearchingGame => 'Suche nach dem Spiel...';

  @override
  String get joinGameScreenGameNotFound =>
      'Spiel konnte nicht gefunden werden.';

  @override
  String get historyScreenHours => 'Stunde/n';

  @override
  String get historyScreenDays => 'Tag/e';

  @override
  String get historyScreenMinutes => 'Minuten';

  @override
  String get historyScreenGamesCardTitle => 'Spiele';

  @override
  String get historyScreenGameTimeCardTitle => 'Spielzeit';

  @override
  String get historyScreenPlayedRoundsCardTitle => 'Gespielte Runden';

  @override
  String get historyScreenTotalPointsTitle => 'Gesammelte Punkte';

  @override
  String get ruleScreenTitle => 'Regeln';

  @override
  String get ruleScreenKamikazePointsLabel => 'Kamikaze Punkte';

  @override
  String get ruleScreenTotalGamePointsLabel => 'Gesammtpunktzahl';

  @override
  String get ruleScreenZeroPointsLabel => 'Rundengewinner erhält 0 Punkte';

  @override
  String get ruleScreenPrecisionLandingLabel => 'Exakt 100';

  @override
  String get ruleScreenSaveButton => 'Speichern';

  @override
  String get ruleScreenResetRulesButton => 'Regeln zurücksetzen';

  @override
  String get ruleScreenTotalPointsHint =>
      '\"Gesammtpunktzahl\" - Lege fest, ab welchem Wert ein Spiel als beendet gelten soll. Trifft ein Spieler genau diesen Wert, mit seiner Punktzahl, dann tritt die Regel \"Exakt 100\" in kraft. Liegt er darüber, dann gilt das Spiel als beendet.';

  @override
  String get ruleScreenKamikazeHint =>
      'Regel: \"Kamikaze\" - Beendet ein Spieler eine Runde mit diesem Wert, dann bekommen alle anderen Spieler 50 Punkte und der Kamikaze Spieler erhält 0 Punkte. Hier kannst du einstellen, bei welchem Wert \"Kamikaze\" inkraft treten soll.';

  @override
  String get ruleScreenRoundWinnerHint =>
      'Regel: \"Punktzahl\" - Der Spieler, der die Runde gewinnt, erhält 0 Punkte. Wird diese Regel deaktiviert, erhält der Rundengewinner die Punktzahl, mit der er/sie gewonnen hat.';

  @override
  String get ruleScreenExactly100Hint =>
      'Regel: \"Exakt 100\" - Trifft ein Spieler die Gesammtpunktzahl, wird sein Punktestand auf 50 Punkte reduziert. Liegt er darüber, ist das Spiel beendet. Du kannst den Wert beliebig anpassen, indem du die Gesammtpunktzahl bearbeitest.';

  @override
  String get developerModeToggled => 'Entwicklermodus konfiguriert';

  @override
  String get aboutScreenTitle => 'Info';

  @override
  String get aboutScreenSendButton => 'Abschicken';

  @override
  String get aboutScreenTextAreaLabel => 'Deine Nachricht';

  @override
  String get aboutScreenSuccess => 'Danke! Dein Feedback wurde abgeschickt.';

  @override
  String get aboutScreenTextAreaDescription =>
      'Gefällt dir die App? Ich würde mich über eine Bewertung freuen!';

  @override
  String get aboutScreenText =>
      'Ich habe diese App entwickelt, um das Spielerlebnis des CABO-Kartenspiels noch besser zu machen.';

  @override
  String get aboutScreenRatingButton => 'Bewerten';

  @override
  String get aboutScreenFeedbackTitle => 'Fehlt noch was? - Gib mir Feedback';

  @override
  String get aboutScreenFeedbackLabel => 'Deine Nachricht';

  @override
  String get aboutScreenFeedbackHint => 'Was können wir verbessern?';

  @override
  String get aboutScreenFeedbackButton => 'Feedback abschicken';

  @override
  String get aboutScreenFeedbackAddImage => 'Bild anhängen';

  @override
  String get aboutScreenFeedbackChangeImage => 'Bild ändern';

  @override
  String get aboutScreenFeedbackSuccess => 'Vielen Dank für dein Feedback!';

  @override
  String get aboutScreenFeedbackError => 'Fehler beim Senden.';

  @override
  String get rateAppTitle => 'Bewerte diese App';

  @override
  String get rateAppDescription =>
      'Wie würdest du deine Erfahrung mit Cabo Board bewerten?';

  @override
  String get feedbackLabel => 'Dein Feedback (Optional)';

  @override
  String get submitRating => 'Absenden';

  @override
  String get maybeLater => 'Vielleicht später';

  @override
  String get winnerDialogTitle => 'Spiel vorbei!';

  @override
  String get hasWonText => 'hat gewonnen!';

  @override
  String get withPointsText => 'mit';

  @override
  String get pointsText => 'Punkten';

  @override
  String get okButton => 'OK';

  @override
  String get streakTitle => 'Streaks';

  @override
  String get streakFiveRoundsWon =>
      'Ein Spieler hat 5 Runden infolge gewonnen.';

  @override
  String get streakSevenRoundsWon =>
      'Ein Spieler hat 7 Runden infolge gewonnen.';

  @override
  String get streakTenRoundsWon =>
      'Ein Spieler hat 10 Runden infolge gewonnen.';

  @override
  String get streakOneHourGame => 'Spiellänge über 1 Stunde';

  @override
  String get streakOneAndHalfHourGame => 'Spiellänge über 1,5 Stunde';

  @override
  String get streakTwoHourGame => 'Spiellänge über 2 Stunde';
}
