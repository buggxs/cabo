// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get gameName => 'CABO';

  @override
  String get gameSubTitle => 'Board';

  @override
  String get menuEntryTrackStats => 'Nowa gra';

  @override
  String get menuEntryGameHistory => 'Historia gier';

  @override
  String get menuEntryJoinGame => 'Dołącz do gry';

  @override
  String get menuEntryGameRules => 'Zasady gry';

  @override
  String get menuEntryGameAboutScreen => 'O aplikacji';

  @override
  String get menuEntrySettings => 'Ustawienia';

  @override
  String get settingsScreenTitle => 'Ustawienia';

  @override
  String get mainMenuSubtitle =>
      'Twój cyfrowy notes punktów do prawdziwej gry karcianej.';

  @override
  String get mainMenuStartBoardDescription =>
      'Utwórz tablicę wyników do gry ze znajomymi przy stole.';

  @override
  String get mainMenuJoinBoardDescription =>
      'Dołącz do istniejącej gry, aby synchronizować punkty z innymi graczami.';

  @override
  String get playerAmountDialogTitle => 'Liczba graczy';

  @override
  String get continueText => 'Dalej';

  @override
  String get loadedOwnRules => 'Wczytano własne zasady.';

  @override
  String get playerNames => 'Imiona graczy';

  @override
  String get choosePlayersTitle => 'Gracze';

  @override
  String get choosePlayersHeroTitle => 'Kto dziś gra?';

  @override
  String get recentPlayerGroups => 'Ostatnie grupy';

  @override
  String get addPlayer => 'Dodaj kolejnego gracza';

  @override
  String get playerLabelPrefix => 'Gracz';

  @override
  String get playerNameHint => 'Wpisz imię...';

  @override
  String get start => 'Start';

  @override
  String get dialogPointsLabel => 'Punkty';

  @override
  String get statsCardRound => 'Runda';

  @override
  String get statsCardTime => 'Czas gry';

  @override
  String get statsNavEndGame => 'Zakończ grę';

  @override
  String get statsNavRules => 'Zasady';

  @override
  String get statsNavOnline => 'Publiczna';

  @override
  String get statsNavShare => 'Udostępnij grę';

  @override
  String get finishCurrentGame => 'Czy na pewno chcesz zakończyć grę?';

  @override
  String get finishCurrentGamePublic =>
      'Czy na pewno chcesz zakończyć grę? Gra zostanie zakończona dla wszystkich graczy.';

  @override
  String get leaveCurrentGame =>
      'Czy na pewno chcesz opuścić grę? Pozostali gracze grają dalej.';

  @override
  String get finishGameDialogButton => 'Tak, zakończ!';

  @override
  String get leaveGameDialogButton => 'Opuść grę.';

  @override
  String get continueGameDialogButton => 'Nie, gramy dalej.';

  @override
  String get dialogTextRoundFinishedBy => 'Kto zakończył rundę?';

  @override
  String get dialogTitleLoadFinishedGame => 'Niezakończona gra';

  @override
  String get dialogTextLoadFinishedGame =>
      'Ostatnia gra nie została zakończona. Wczytać ją?';

  @override
  String get loadGameDialogButton => 'Tak, wczytaj grę!';

  @override
  String get notLoadGameDialogButton => 'Nie, nie wczytuj.';

  @override
  String get announcementDialogOkayButton => 'OK';

  @override
  String get enterDialogButton => 'Zapisz';

  @override
  String get enterPointsDialogTitle => 'Wpisz punkty';

  @override
  String get dialogRoundFinishedTitle => 'Runda zakończona!';

  @override
  String get dialogCancel => 'Anuluj';

  @override
  String get dialogEnterPoints => 'Wpisz punkty';

  @override
  String dialogPointsRoundFinished(int round) {
    return 'Runda $round zakończona';
  }

  @override
  String get dialogKeypadNext => 'Dalej';

  @override
  String get dialogKeypadDone => 'Gotowe';

  @override
  String get publishDialogTitle => 'Opublikuj grę';

  @override
  String get publishDialogReadyToPublish =>
      'Twoja gra jest gotowa do publikacji.';

  @override
  String get publishDialogLoading => 'Publikowanie gry...';

  @override
  String get publishDialogGamePublished => 'Twoja gra jest teraz publiczna';

  @override
  String get publishDialogJoinedGame => 'Jesteś w publicznej grze';

  @override
  String get publishDialogFriendsCanJoin =>
      'Inni mogą dołączyć do gry za pomocą tego kodu QR:';

  @override
  String get publishDialogPublish => 'Opublikuj grę';

  @override
  String get publishDialogNextSteps =>
      'Wpisuj punkty po każdej rundzie — pozostali gracze widzą je od razu.';

  @override
  String get publishDialogContinueToGame => 'Przejdź do gry';

  @override
  String get publishDialogCodeStaysAvailable =>
      'Kod znajdziesz w każdej chwili w zakładce „Publiczna”.';

  @override
  String get publishDialogFailedToPublish => 'Nie udało się opublikować gry.';

  @override
  String get authScreenSignInHeadline => 'Gotowy na kolejną przygodę?';

  @override
  String get authScreenSignInToPublish =>
      'Zarejestruj się, aby opublikować grę.';

  @override
  String get authScreenSignInPrivacyHint =>
      'Bezpiecznie i szybko. Nigdy nie udostępniamy Twoich prywatnych danych.';

  @override
  String get authScreenSignInWithGoogle => 'Zaloguj się przez Google';

  @override
  String get authScreenSignInFailed =>
      'Logowanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get authScreenSignInWithEmail => 'Logowanie/rejestracja przez e-mail';

  @override
  String get authScreenEmail => 'E-mail';

  @override
  String get authScreenPassword => 'Hasło';

  @override
  String get authScreenPasswordRepeat => 'Potwierdź hasło';

  @override
  String get authScreenSignIn => 'Zaloguj się';

  @override
  String get authScreenAlreadyAccount => 'Masz już konto? Zaloguj się';

  @override
  String get authScreenRegister => 'Zarejestruj się';

  @override
  String get authScreenPasswortMissmatch => 'Hasła nie są zgodne.';

  @override
  String get authScreenStartRegister => 'Nie masz konta? Zarejestruj się';

  @override
  String get authScreenBack => 'Wstecz';

  @override
  String get authScreenShowPassword => 'Pokaż hasło';

  @override
  String get authScreenHidePassword => 'Ukryj hasło';

  @override
  String get authScreenForgotPassword => 'Nie pamiętasz hasła?';

  @override
  String get authScreenPasswordResetSent =>
      'Wysłaliśmy Ci link do zresetowania hasła.';

  @override
  String get verifyEmailUseOtherAccount => 'Użyj innego adresu';

  @override
  String get authScreenEmailAlreadyInUse =>
      'Konto z tym adresem e-mail już istnieje.';

  @override
  String get authScreenLinkConflictHint =>
      'Zaloguj się, aby korzystać z tego konta. Gry online rozpoczęte na tym urządzeniu nie zostaną z nim połączone.';

  @override
  String get authScreenInvalidCredentials => 'Nieprawidłowy e-mail lub hasło.';

  @override
  String get authScreenWeakPassword => 'Użyj co najmniej 8 znaków.';

  @override
  String get authScreenInvalidEmail => 'Podaj prawidłowy adres e-mail.';

  @override
  String get authScreenTooManyRequests => 'Zbyt wiele prób. Poczekaj chwilę.';

  @override
  String get authScreenNetworkError => 'Brak połączenia. Spróbuj ponownie.';

  @override
  String get authScreenEmailRequired => 'Podaj swój adres e-mail.';

  @override
  String get authScreenPasswordRequired => 'Podaj hasło.';

  @override
  String get verifyEmailTitle => 'Potwierdź swój e-mail';

  @override
  String verifyEmailDescription(String email) {
    return 'Wysłaliśmy link potwierdzający na adres $email. Otwórz go i wróć tutaj.';
  }

  @override
  String get authScreenMailSpamHint =>
      'Nie dostałeś maila? Sprawdź folder spam i oznacz wiadomość jako „To nie spam” — wtedy następna dotrze.';

  @override
  String get verifyEmailResend => 'Wyślij ponownie';

  @override
  String verifyEmailResendIn(int seconds) {
    return 'Wyślij ponownie za $seconds s';
  }

  @override
  String get verifyEmailResent => 'Mail wysłany.';

  @override
  String get verifyEmailCheckNow => 'Potwierdziłem';

  @override
  String get verifyEmailStillPending =>
      'Jeszcze nie potwierdzono. Otwórz link w mailu.';

  @override
  String get accountCardTitle => 'Konto';

  @override
  String get accountCardAnonymous => 'Grasz bez konta';

  @override
  String get accountCardAnonymousHint => 'Zarejestruj się, aby publikować gry.';

  @override
  String get accountCardVerified => 'E-mail potwierdzony';

  @override
  String get accountCardUnverified => 'E-mail jeszcze niepotwierdzony';

  @override
  String get accountCardSignOut => 'Wyloguj się';

  @override
  String get joinGameScreenScanToJoin =>
      'Zeskanuj kod QR, aby dołączyć do gry.';

  @override
  String get joinGameScreenGameFound => 'Znaleziono grę!';

  @override
  String get joinGameScreenGameRounds => 'Rundy';

  @override
  String get joinGameScreenGamePoints => 'Punkty';

  @override
  String get joinGameScreenLoadingStatus => 'Rozpoznano ID gry';

  @override
  String get joinGameScreenSearchingGame => 'Szukanie gry...';

  @override
  String get joinGameScreenGameNotFound => 'Nie znaleziono gry.';

  @override
  String get joinGameScreenGameAlreadyFinished =>
      'Ta gra już się zakończyła i nie można do niej dołączyć.';

  @override
  String get joinGameScreenScanQrCode => 'Zeskanuj kod QR';

  @override
  String get joinGameScreenEnterIdInstead => 'Wpisz ID';

  @override
  String get joinGameScreenGameIdLabel => 'ID gry (np. cabo-123-xyz)';

  @override
  String get joinGameScreenSearchButton => 'Szukaj';

  @override
  String get joinGameScreenEnterIdToJoin =>
      'Wpisz ID gry, aby do niej dołączyć.';

  @override
  String get joinGameScreenOrDivider => 'lub';

  @override
  String get joinGameScreenManualLabel => 'ID gry';

  @override
  String get joinGameScreenSearchGameButton => 'Szukaj gry';

  @override
  String get joinGameScreenJoinButton => 'Dołącz do gry';

  @override
  String get historyScreenHours => 'Godz.';

  @override
  String get historyScreenDays => 'Dni';

  @override
  String get historyScreenMinutes => 'Min.';

  @override
  String get historyScreenGamesCardTitle => 'Gry';

  @override
  String get historyScreenGameTimeCardTitle => 'Czas gry';

  @override
  String get historyScreenPlayedRoundsCardTitle => 'Rozegrane rundy';

  @override
  String get historyScreenTotalPointsTitle => 'Zebrane punkty';

  @override
  String get historyScreenTitle => 'Historia gier';

  @override
  String get historyScreenSubtitle => 'Twoje przygody przy kuchennym stole';

  @override
  String get historyScreenStreaksActive => 'Aktywne serie';

  @override
  String get historyScreenDaysShort => 'd';

  @override
  String get historyScreenHoursShort => 'godz.';

  @override
  String get ruleScreenTitle => 'Zasady';

  @override
  String get ruleScreenKamikazePointsLabel => 'Punkty Kamikaze';

  @override
  String get ruleScreenTotalGamePointsLabel => 'Wynik końcowy';

  @override
  String get ruleScreenZeroPointsLabel => 'Zwycięzca rundy: 0 punktów';

  @override
  String get ruleScreenPrecisionLandingLabel => 'Dokładnie 100';

  @override
  String get ruleScreenSaveButton => 'Zapisz';

  @override
  String get ruleScreenResetRulesButton => 'Przywróć zasady';

  @override
  String get ruleScreenTotalPointsHint =>
      '„Wynik końcowy” — określ, przy jakiej liczbie punktów gra się kończy. Jeśli gracz osiągnie dokładnie tę wartość, obowiązuje zasada „Dokładnie 100”. Jeśli ją przekroczy, gra się kończy.';

  @override
  String get ruleScreenKamikazeHint =>
      'Zasada „Kamikaze” — jeśli gracz zakończy rundę z tą wartością, wszyscy pozostali dostają punkty Kamikaze, a gracz Kamikaze 0. Tutaj ustawisz wartość, przy której działa „Kamikaze”.';

  @override
  String get ruleScreenRoundWinnerHint =>
      'Zasada „Punktacja” — gracz, który wygrywa rundę, dostaje 0 punktów. Po wyłączeniu tej zasady zwycięzca dostaje tyle punktów, z iloma wygrał.';

  @override
  String get ruleScreenExactly100Hint =>
      'Zasada „Dokładnie 100” — jeśli gracz osiągnie dokładnie wynik końcowy, jego punkty zostają zmniejszone o połowę. Jeśli go przekroczy, gra się kończy. Wartość zmienisz, edytując wynik końcowy.';

  @override
  String get ruleScreenScoreSection => 'Limity punktów';

  @override
  String get ruleScreenMechanicsSection => 'Mechanika gry';

  @override
  String get ruleScreenTotalPointsDescription =>
      'Gra kończy się, gdy tylko gracz przekroczy tę liczbę punktów.';

  @override
  String get ruleScreenKamikazeDescription =>
      'Zasada specjalna: kto zakończy rundę z dokładnie tą liczbą punktów, dostaje 0 — wszyscy pozostali dostają tę liczbę. 0 wyłącza zasadę.';

  @override
  String get ruleScreenZeroPointsDescription =>
      'Nagroda za wygraną rundę: zwycięzca dostaje 0 zamiast punktów z ręki.';

  @override
  String get ruleScreenPrecisionLandingDescription =>
      'Szansa na powrót: kto trafi dokładnie w wynik końcowy, ma punkty zmniejszone o połowę.';

  @override
  String get roundBadgeKamikaze => 'KAMIKAZE';

  @override
  String get roundBadgeKamikazeTooltip =>
      'Runda Kamikaze: gracz Kamikaze dostaje 0, wszyscy pozostali dostają punkty Kamikaze.';

  @override
  String get roundBadgePenaltyTooltip =>
      'Nieudane cabo: 5 punktów karnych do punktów z ręki.';

  @override
  String get roundBadgePrecisionLandingTooltip =>
      'Idealne trafienie: wynik zmniejszono do połowy wyniku końcowego.';

  @override
  String get ruleScreenPointsSuffix => 'pkt';

  @override
  String get ruleScreenInfoCard =>
      'Te zasady obowiązują wszystkich aktywnych graczy w tej rundzie. Zmiany w trakcie gry mogą prowadzić do nieoczekiwanego liczenia punktów.';

  @override
  String get developerModeToggled => 'Przełączono tryb dewelopera';

  @override
  String get aboutScreenTitle => 'O aplikacji';

  @override
  String get aboutScreenSendButton => 'Wyślij';

  @override
  String get aboutScreenTextAreaLabel => 'Twoja wiadomość';

  @override
  String get aboutScreenSuccess => 'Dzięki! Twoja opinia została wysłana.';

  @override
  String get aboutScreenTextAreaDescription =>
      'Podoba Ci się aplikacja? Będzie mi bardzo miło, jeśli ją ocenisz!';

  @override
  String get aboutScreenText =>
      'Stworzyłem tę aplikację, aby gra w karty CABO była jeszcze przyjemniejsza.';

  @override
  String get aboutScreenRatingButton => 'Oceń';

  @override
  String get aboutScreenFeedbackTitle => 'Czegoś brakuje?';

  @override
  String get aboutScreenFeedbackLabel => 'Twoja wiadomość';

  @override
  String get aboutScreenFeedbackHint => 'Co możemy poprawić?';

  @override
  String get aboutScreenFeedbackButton => 'Wyślij opinię';

  @override
  String get aboutScreenFeedbackAddImage => 'Dołącz obraz';

  @override
  String get aboutScreenFeedbackChangeImage => 'Zmień obraz';

  @override
  String get aboutScreenFeedbackSuccess => 'Dziękuję za Twoją opinię!';

  @override
  String get aboutScreenFeedbackError => 'Błąd podczas wysyłania opinii.';

  @override
  String get aboutScreenRatingHeadline => 'Podoba Ci się aplikacja?';

  @override
  String get aboutScreenRatingDescription =>
      'Bardzo ucieszy mnie ocena w sklepie! To pomaga Cabo Board się rozwijać.';

  @override
  String get aboutScreenFeedbackSubtitle => 'Daj mi znać!';

  @override
  String get aboutScreenEmailLabel => 'E-mail (opcjonalnie)';

  @override
  String get aboutScreenEmailHint => 'Twój adres e-mail';

  @override
  String get aboutScreenEmailInvalid => 'Podaj prawidłowy adres e-mail.';

  @override
  String get aboutScreenFeedbackRequired => 'Wpisz wiadomość.';

  @override
  String get aboutScreenFunFact =>
      'Czy wiesz, że słowo „Cabo” oznacza po hiszpańsku „koniec”? Dokładnie to wołasz, gdy chcesz wygrać!';

  @override
  String get rateAppTitle => 'Oceń aplikację';

  @override
  String get rateAppDescription => 'Jak oceniasz swoje wrażenia z Cabo Board?';

  @override
  String get feedbackLabel => 'Twoja opinia (opcjonalnie)';

  @override
  String get submitRating => 'Wyślij';

  @override
  String get maybeLater => 'Może później';

  @override
  String get winnerDialogTitle => 'Koniec gry!';

  @override
  String get hasWonText => 'wygrywa!';

  @override
  String get withPointsText => 'z wynikiem';

  @override
  String get pointsText => 'pkt';

  @override
  String get okButton => 'OK';

  @override
  String get endGameRankingTitle => 'Ranking';

  @override
  String get endGameBackToMenu => 'Powrót do menu';

  @override
  String get endGameDurationLabel => 'Czas gry';

  @override
  String get endGameDurationUnitMinutes => 'min';

  @override
  String get endGameDurationUnitHours => 'godz.';

  @override
  String get endGameRoundsLabel => 'Rundy';

  @override
  String get endGameRoundsUnit => 'Łącznie';

  @override
  String get endGameDetailedTitle => 'Szczegółowe statystyki';

  @override
  String get endGameStatTotal => 'Suma';

  @override
  String get endGameStatCaboZero => 'Cabo-0';

  @override
  String get endGameStatPenalty => 'Kary';

  @override
  String get endGameStatAverage => 'Śr. / rd';

  @override
  String get endGamePointsShort => 'pkt';

  @override
  String get endGameHighlightsTitle => 'Najlepsze momenty';

  @override
  String get endGameHighlightBestRound => 'Najlepsza runda (najmniej pkt)';

  @override
  String get endGameHighlightTotalSuffix => 'łącznie';

  @override
  String get endGameRoundLabel => 'Runda';

  @override
  String get endGameHighlightLongestStreak => 'Najdłuższa seria zwycięstw';

  @override
  String endGameHighlightStreakRounds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rundy z rzędu',
      many: '$count rund z rzędu',
      few: '$count rundy z rzędu',
      one: '1 runda z rzędu',
    );
    return '$_temp0';
  }

  @override
  String get endGameStreakWinTitle => 'Seria zwycięstw';

  @override
  String get endGameStreakDurationTitle => 'Długa gra';

  @override
  String get streakTitle => 'Serie';

  @override
  String get streakFiveRoundsWon => 'Gracz wygrał 5 rund z rzędu.';

  @override
  String get streakSevenRoundsWon => 'Gracz wygrał 7 rund z rzędu.';

  @override
  String get streakTenRoundsWon => 'Gracz wygrał 10 rund z rzędu.';

  @override
  String get streakOneHourGame => 'Gra dłuższa niż 1 godzina';

  @override
  String get streakOneAndHalfHourGame => 'Gra dłuższa niż 1,5 godziny';

  @override
  String get streakTwoHourGame => 'Gra dłuższa niż 2 godziny';

  @override
  String get designSectionTitle => 'Wygląd';

  @override
  String get designSectionSubtitle => 'Wybierz wygląd aplikacji';

  @override
  String get designModern => 'Nowoczesny';

  @override
  String get designClassic => 'Klasyczny';

  @override
  String get designModernDescription => 'Jasny, nowoczesny wygląd.';

  @override
  String get designClassicDescription =>
      'Oryginalny ciemnozielony wygląd z obrazem w tle.';

  @override
  String get errorScreenTitle => 'Błąd';

  @override
  String get errorScreenMessage => 'Coś poszło nie tak.';

  @override
  String get statsScreenNoPlayers => 'Nie znaleziono graczy!';
}
