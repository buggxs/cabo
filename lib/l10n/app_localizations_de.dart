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
  String get menuEntrySettings => 'Einstellungen';

  @override
  String get settingsScreenTitle => 'Einstellungen';

  @override
  String get mainMenuSubtitle =>
      'Dein digitaler Punkteblock für das echte Kartenspiel.';

  @override
  String get mainMenuStartBoardDescription =>
      'Erstelle ein Punkteboard für dein Spiel mit Freunden vor Ort.';

  @override
  String get mainMenuJoinBoardDescription =>
      'Tritt einem bestehenden Spiel bei, um Punkte mit anderen Spielern zu synchronisieren.';

  @override
  String get playerAmountDialogTitle => 'Spieler Anzahl';

  @override
  String get continueText => 'Weiter';

  @override
  String get loadedOwnRules => 'Eigene Regeln geladen.';

  @override
  String get playerNames => 'Spieler Namen';

  @override
  String get choosePlayersTitle => 'Spieler';

  @override
  String get choosePlayersHeroTitle => 'Wer spielt heute?';

  @override
  String get recentPlayerGroups => 'Letzte Spielergruppen';

  @override
  String get addPlayer => 'Weiteren Spieler hinzufügen';

  @override
  String get playerLabelPrefix => 'Spieler';

  @override
  String get playerNameHint => 'Name eingeben...';

  @override
  String get start => 'Starten';

  @override
  String get dialogPointsLabel => 'Punkte';

  @override
  String get statsCardRound => 'Runde';

  @override
  String get statsCardTime => 'Spielzeit';

  @override
  String get statsNavEndGame => 'Spiel beenden';

  @override
  String get statsNavRules => 'Regeln';

  @override
  String get statsNavOnline => 'Öffentlich';

  @override
  String get statsNavShare => 'Spiel teilen';

  @override
  String get finishCurrentGame => 'Möchtest du das Spiel wirklich beenden?';

  @override
  String get finishCurrentGamePublic =>
      'Möchtest du das Spiel wirklich beenden? Das Spiel wird für alle Teilnehmer beendet.';

  @override
  String get leaveCurrentGame =>
      'Möchtest du das Spiel wirklich verlassen? Die anderen Spieler spielen weiter.';

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
  String get announcementDialogOkayButton => 'Okay';

  @override
  String get enterDialogButton => 'Eintragen';

  @override
  String get enterPointsDialogTitle => 'Enter points';

  @override
  String get dialogRoundFinishedTitle => 'Runde beendet!';

  @override
  String get dialogCancel => 'Abbrechen';

  @override
  String get dialogEnterPoints => 'Punkte eintragen';

  @override
  String dialogPointsRoundFinished(int round) {
    return 'Runde $round beendet';
  }

  @override
  String get dialogKeypadNext => 'Weiter';

  @override
  String get dialogKeypadDone => 'Fertig';

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
  String get authScreenSignInHeadline => 'Bereit für dein nächstes Abenteuer?';

  @override
  String get authScreenSignInToPublish =>
      'Melde dich an, um dein Spiel zu veröffentlichen.';

  @override
  String get authScreenSignInPrivacyHint =>
      'Sicher und schnell. Wir teilen niemals deine privaten Daten.';

  @override
  String get authScreenSignInWithGoogle => 'Mit Google anmelden';

  @override
  String get authScreenSignInFailed =>
      'Anmeldung fehlgeschlagen. Bitte versuche es erneut.';

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
  String get authScreenEmailAlreadyInUse =>
      'Für diese E-Mail existiert schon ein Konto.';

  @override
  String get authScreenLinkConflictHint =>
      'Melde dich an, um dieses Konto zu nutzen. Online-Spiele, die du auf diesem Gerät gestartet hast, bleiben dann nicht damit verknüpft.';

  @override
  String get authScreenSignInWithEmailAction => 'Weiter mit E-Mail';

  @override
  String get authScreenInvalidCredentials => 'E-Mail oder Passwort ist falsch.';

  @override
  String get authScreenWeakPassword => 'Bitte nutze mindestens 6 Zeichen.';

  @override
  String get authScreenInvalidEmail =>
      'Bitte gib eine gültige E-Mail-Adresse ein.';

  @override
  String get authScreenTooManyRequests =>
      'Zu viele Versuche. Bitte warte einen Moment.';

  @override
  String get authScreenNetworkError =>
      'Keine Verbindung. Bitte versuche es erneut.';

  @override
  String get authScreenEmailRequired => 'Bitte gib deine E-Mail-Adresse ein.';

  @override
  String get authScreenPasswordRequired => 'Bitte gib ein Passwort ein.';

  @override
  String get verifyEmailTitle => 'Bestätige deine E-Mail';

  @override
  String verifyEmailDescription(String email) {
    return 'Wir haben einen Bestätigungslink an $email geschickt. Öffne ihn und komm dann hierher zurück.';
  }

  @override
  String get verifyEmailSpamHint =>
      'Keine Mail? Schau bitte auch im Spam-Ordner.';

  @override
  String get verifyEmailResend => 'Erneut senden';

  @override
  String verifyEmailResendIn(int seconds) {
    return 'Erneut senden in ${seconds}s';
  }

  @override
  String get verifyEmailResent => 'Mail verschickt.';

  @override
  String get verifyEmailCheckNow => 'Ich habe bestätigt';

  @override
  String get verifyEmailStillPending =>
      'Noch nicht bestätigt. Bitte öffne den Link in der Mail.';

  @override
  String get accountCardTitle => 'Konto';

  @override
  String get accountCardAnonymous => 'Du spielst ohne Konto';

  @override
  String get accountCardAnonymousHint =>
      'Registriere dich, um Spiele zu veröffentlichen.';

  @override
  String get accountCardVerified => 'E-Mail bestätigt';

  @override
  String get accountCardUnverified => 'E-Mail noch nicht bestätigt';

  @override
  String get accountCardSignOut => 'Abmelden';

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
  String get joinGameScreenGameAlreadyFinished =>
      'Dieses Spiel ist bereits beendet und kann nicht mehr betreten werden.';

  @override
  String get joinGameScreenScanQrCode => 'QR-Code scannen';

  @override
  String get joinGameScreenEnterIdInstead => 'Stattdessen ID eingeben';

  @override
  String get joinGameScreenGameIdLabel => 'Game-ID (z. B. cabo-123-xyz)';

  @override
  String get joinGameScreenSearchButton => 'Suchen';

  @override
  String get joinGameScreenEnterIdToJoin =>
      'Gib die Spiel-ID ein, um einem Spiel beizutreten.';

  @override
  String get joinGameScreenOrDivider => 'oder';

  @override
  String get joinGameScreenManualLabel => 'Spiel-ID';

  @override
  String get joinGameScreenSearchGameButton => 'Spiel suchen';

  @override
  String get joinGameScreenJoinButton => 'Spiel beitreten';

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
  String get historyScreenTitle => 'Spielverlauf';

  @override
  String get historyScreenSubtitle => 'Deine Abenteuer am Küchentisch';

  @override
  String get historyScreenStreaksActive => 'Streaks aktiv';

  @override
  String get historyScreenDaysShort => 'Tag/e';

  @override
  String get historyScreenHoursShort => 'Std';

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
  String get ruleScreenScoreSection => 'Punkte-Limits';

  @override
  String get ruleScreenMechanicsSection => 'Spielmechanik';

  @override
  String get ruleScreenTotalPointsDescription =>
      'Spiel endet, sobald ein Spieler diese Punktzahl erreicht.';

  @override
  String get ruleScreenKamikazeDescription =>
      'Spezialregel: Wenn ein Spieler exakt diese Punktzahl am Ende erreicht, passiert etwas Besonderes.';

  @override
  String get ruleScreenZeroPointsDescription =>
      'Belohnt den Sieg in einer Runde.';

  @override
  String get ruleScreenPrecisionLandingDescription =>
      'Eine Chance auf ein Comeback.';

  @override
  String get ruleScreenPointsSuffix => 'Pkt.';

  @override
  String get ruleScreenInfoCard =>
      'Diese Regeln gelten für alle aktiven Spieler in dieser Runde. Änderungen während eines Spiels können zu unerwarteten Punkteberechnungen führen.';

  @override
  String get developerModeToggled => 'Entwicklermodus konfiguriert';

  @override
  String get aboutScreenTitle => 'Über die App';

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
  String get aboutScreenFeedbackTitle => 'Etwas vergessen?';

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
  String get aboutScreenRatingHeadline => 'Gefällt dir die App?';

  @override
  String get aboutScreenRatingDescription =>
      'Ich würde mich riesig über eine Bewertung im Store freuen! Das hilft Cabo Board zu wachsen.';

  @override
  String get aboutScreenFeedbackSubtitle => 'Lass es mich wissen!';

  @override
  String get aboutScreenEmailLabel => 'E-Mail (optional)';

  @override
  String get aboutScreenEmailHint => 'Deine E-Mail Adresse';

  @override
  String get aboutScreenEmailInvalid =>
      'Bitte gib eine gültige E-Mail Adresse ein.';

  @override
  String get aboutScreenFeedbackRequired => 'Bitte gib eine Nachricht ein.';

  @override
  String get aboutScreenFunFact =>
      'Wusstest du schon? Das Wort \"Cabo\" bedeutet auf Spanisch \"Ende\" – genau das, was man ruft, wenn man gewinnen will!';

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
  String get endGameRankingTitle => 'Rangliste';

  @override
  String get endGameBackToMenu => 'Zurück zum Menü';

  @override
  String get endGameDurationLabel => 'Spieldauer';

  @override
  String get endGameDurationUnitMinutes => 'Min';

  @override
  String get endGameDurationUnitHours => 'Std';

  @override
  String get endGameRoundsLabel => 'Runden';

  @override
  String get endGameRoundsUnit => 'Gesamt';

  @override
  String get endGameDetailedTitle => 'Detaillierte Werte';

  @override
  String get endGameStatTotal => 'Gesamt';

  @override
  String get endGameStatCaboZero => 'Cabo-0';

  @override
  String get endGameStatPenalty => 'Straf-Pkt';

  @override
  String get endGameStatAverage => 'Ø / Rd';

  @override
  String get endGamePointsShort => 'Pkt';

  @override
  String get endGameHighlightsTitle => 'Spiel-Highlights';

  @override
  String get endGameHighlightBestRound => 'Beste Runde (Low Score)';

  @override
  String get endGameHighlightTotalSuffix => 'gesamt';

  @override
  String get endGameRoundLabel => 'Runde';

  @override
  String get endGameHighlightLongestStreak => 'Längste Siegesserie';

  @override
  String get endGameHighlightStreakSuffix => 'Runden in Folge';

  @override
  String get endGameStreakWinTitle => 'Siegesserie';

  @override
  String get endGameStreakDurationTitle => 'Lange Partie';

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

  @override
  String get designSectionTitle => 'Design';

  @override
  String get designSectionSubtitle => 'Wähle das Aussehen der App';

  @override
  String get designModern => 'Modern';

  @override
  String get designClassic => 'Klassisch';

  @override
  String get designModernDescription => 'Das helle, moderne Design.';

  @override
  String get designClassicDescription =>
      'Das ursprüngliche dunkelgrüne Design mit Hintergrundbild.';
}
