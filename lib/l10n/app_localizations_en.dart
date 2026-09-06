// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get gameName => 'CABO';

  @override
  String get gameSubTitle => 'Board';

  @override
  String get menuEntryTrackStats => 'Start Game';

  @override
  String get menuEntryGameHistory => 'Game History';

  @override
  String get menuEntryJoinGame => 'Join Game';

  @override
  String get menuEntryGameRules => 'Game Rules';

  @override
  String get menuEntryGameAboutScreen => 'About';

  @override
  String get menuEntrySettings => 'Settings';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get mainMenuSubtitle =>
      'Your digital scorepad for the physical card game.';

  @override
  String get mainMenuStartBoardDescription =>
      'Create a scoreboard for your game with friends in person.';

  @override
  String get mainMenuJoinBoardDescription =>
      'Join an existing game to sync points with other players.';

  @override
  String get playerAmountDialogTitle => 'Player Amount';

  @override
  String get continueText => 'Continue';

  @override
  String get loadedOwnRules => 'Own rules loaded.';

  @override
  String get playerNames => 'Player Names';

  @override
  String get choosePlayersTitle => 'Players';

  @override
  String get choosePlayersHeroTitle => 'Who\'s playing today?';

  @override
  String get recentPlayerGroups => 'Recent groups';

  @override
  String get addPlayer => 'Add another player';

  @override
  String get playerLabelPrefix => 'Player';

  @override
  String get playerNameHint => 'Enter name...';

  @override
  String get start => 'Start';

  @override
  String get dialogPointsLabel => 'Points';

  @override
  String get statsCardRound => 'Round';

  @override
  String get statsCardTime => 'Play time';

  @override
  String get statsNavEndGame => 'End Game';

  @override
  String get statsNavRules => 'Rules';

  @override
  String get statsNavOnline => 'Public';

  @override
  String get statsNavShare => 'Share game';

  @override
  String get finishCurrentGame => 'Do you really want to finish the game?';

  @override
  String get finishCurrentGamePublic =>
      'Do you really want to finish the game? The game will be finished for all players.';

  @override
  String get leaveCurrentGame =>
      'Do you really want to leave the game? The other players will keep playing.';

  @override
  String get finishGameDialogButton => 'Yes, finish!';

  @override
  String get leaveGameDialogButton => 'Leave game.';

  @override
  String get continueGameDialogButton => 'No, keep playing.';

  @override
  String get dialogTextRoundFinishedBy => 'Who finished the round?';

  @override
  String get dialogTitleLoadFinishedGame => 'Not Finished Game';

  @override
  String get dialogTextLoadFinishedGame =>
      'You have not finished the last game, should it be loaded?';

  @override
  String get loadGameDialogButton => 'Yes, load game!';

  @override
  String get notLoadGameDialogButton => 'No, do not load.';

  @override
  String get announcementDialogOkayButton => 'Okay';

  @override
  String get enterDialogButton => 'Save';

  @override
  String get enterPointsDialogTitle => 'Enter points';

  @override
  String get dialogRoundFinishedTitle => 'Round finished!';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogEnterPoints => 'Enter points';

  @override
  String dialogPointsRoundFinished(int round) {
    return 'Round $round finished';
  }

  @override
  String get dialogKeypadNext => 'Next';

  @override
  String get dialogKeypadDone => 'Done';

  @override
  String get publishDialogTitle => 'Publish Game';

  @override
  String get publishDialogReadyToPublish =>
      'Your game is ready to be published.';

  @override
  String get publishDialogLoading => 'Your game will be published...';

  @override
  String get publishDialogGamePublished => 'Your game is now public';

  @override
  String get publishDialogJoinedGame => 'You are in a public game';

  @override
  String get publishDialogFriendsCanJoin =>
      'Others can join the game using this QR code:';

  @override
  String get publishDialogPublish => 'Publish game';

  @override
  String get publishDialogFailedToPublish => 'Game could not be published.';

  @override
  String get authScreenSignInHeadline => 'Ready for your next adventure?';

  @override
  String get authScreenSignInToPublish => 'Sign up to publish your game.';

  @override
  String get authScreenSignInPrivacyHint =>
      'Safe and fast. We never share your private data.';

  @override
  String get authScreenSignInWithGoogle => 'Log in with Google';

  @override
  String get authScreenSignInFailed => 'Sign in failed. Please try again.';

  @override
  String get authScreenSignInWithEmail => 'Log in/register with e-mail';

  @override
  String get authScreenEmail => 'E-Mail';

  @override
  String get authScreenPassword => 'Password';

  @override
  String get authScreenPasswordRepeat => 'Confirm password';

  @override
  String get authScreenSignIn => 'Log in';

  @override
  String get authScreenAlreadyAccount => 'Already have an account? Log in';

  @override
  String get authScreenRegister => 'Register';

  @override
  String get authScreenPasswortMissmatch => 'Passwords do not match.';

  @override
  String get authScreenStartRegister => 'No account yet? Register';

  @override
  String get authScreenBack => 'Back';

  @override
  String get authScreenShowPassword => 'Show password';

  @override
  String get authScreenHidePassword => 'Hide password';

  @override
  String get authScreenForgotPassword => 'Forgot your password?';

  @override
  String get authScreenPasswordResetSent =>
      'We sent you a link to reset your password.';

  @override
  String get verifyEmailUseOtherAccount => 'Use a different address';

  @override
  String get authScreenEmailAlreadyInUse =>
      'An account already exists for this e-mail.';

  @override
  String get authScreenLinkConflictHint =>
      'Log in to use that account. Online games you started on this device will not be linked to it.';

  @override
  String get authScreenInvalidCredentials => 'E-mail or password is wrong.';

  @override
  String get authScreenWeakPassword => 'Please use at least 8 characters.';

  @override
  String get authScreenInvalidEmail => 'Please enter a valid e-mail address.';

  @override
  String get authScreenTooManyRequests =>
      'Too many attempts. Please wait a moment.';

  @override
  String get authScreenNetworkError => 'No connection. Please try again.';

  @override
  String get authScreenEmailRequired => 'Please enter your e-mail address.';

  @override
  String get authScreenPasswordRequired => 'Please enter a password.';

  @override
  String get verifyEmailTitle => 'Confirm your e-mail';

  @override
  String verifyEmailDescription(String email) {
    return 'We sent a confirmation link to $email. Open it, then come back here.';
  }

  @override
  String get authScreenMailSpamHint =>
      'No mail? Please check your spam folder and mark it as “not spam” — that helps the next one arrive.';

  @override
  String get verifyEmailResend => 'Send again';

  @override
  String verifyEmailResendIn(int seconds) {
    return 'Send again in ${seconds}s';
  }

  @override
  String get verifyEmailResent => 'Mail sent.';

  @override
  String get verifyEmailCheckNow => 'I have confirmed';

  @override
  String get verifyEmailStillPending =>
      'Not confirmed yet. Please open the link in the mail.';

  @override
  String get accountCardTitle => 'Account';

  @override
  String get accountCardAnonymous => 'Playing without an account';

  @override
  String get accountCardAnonymousHint => 'Register to publish games.';

  @override
  String get accountCardVerified => 'E-mail confirmed';

  @override
  String get accountCardUnverified => 'E-mail not confirmed yet';

  @override
  String get accountCardSignOut => 'Sign out';

  @override
  String get joinGameScreenScanToJoin => 'Scan a QR code to join a game.';

  @override
  String get joinGameScreenGameFound => 'Game found!';

  @override
  String get joinGameScreenGameRounds => 'Rounds';

  @override
  String get joinGameScreenGamePoints => 'Points';

  @override
  String get joinGameScreenLoadingStatus => 'A game ID was recognized';

  @override
  String get joinGameScreenSearchingGame => 'Search for the game...';

  @override
  String get joinGameScreenGameNotFound => 'Game could not be found.';

  @override
  String get joinGameScreenGameAlreadyFinished =>
      'This game has already finished and can no longer be joined.';

  @override
  String get joinGameScreenScanQrCode => 'Scan QR code';

  @override
  String get joinGameScreenEnterIdInstead => 'Enter ID instead';

  @override
  String get joinGameScreenGameIdLabel => 'Game ID (e.g. cabo-123-xyz)';

  @override
  String get joinGameScreenSearchButton => 'Search';

  @override
  String get joinGameScreenEnterIdToJoin => 'Enter the game ID to join a game.';

  @override
  String get joinGameScreenOrDivider => 'or';

  @override
  String get joinGameScreenManualLabel => 'Game ID';

  @override
  String get joinGameScreenSearchGameButton => 'Search game';

  @override
  String get joinGameScreenJoinButton => 'Join game';

  @override
  String get historyScreenHours => 'Hours';

  @override
  String get historyScreenDays => 'Day/s';

  @override
  String get historyScreenMinutes => 'Minutes';

  @override
  String get historyScreenGamesCardTitle => 'Games';

  @override
  String get historyScreenGameTimeCardTitle => 'Game Time';

  @override
  String get historyScreenPlayedRoundsCardTitle => 'Played Rounds';

  @override
  String get historyScreenTotalPointsTitle =>
      'Total amount of collected Points';

  @override
  String get historyScreenTitle => 'Game History';

  @override
  String get historyScreenSubtitle => 'Your adventures at the kitchen table';

  @override
  String get historyScreenStreaksActive => 'Streaks active';

  @override
  String get historyScreenDaysShort => 'd';

  @override
  String get historyScreenHoursShort => 'hrs';

  @override
  String get ruleScreenTitle => 'Rules';

  @override
  String get ruleScreenKamikazePointsLabel => 'Kamikaze Points';

  @override
  String get ruleScreenTotalGamePointsLabel => 'Total score';

  @override
  String get ruleScreenZeroPointsLabel => 'Round Winner get 0 Points';

  @override
  String get ruleScreenPrecisionLandingLabel => 'Exactly 100';

  @override
  String get ruleScreenSaveButton => 'Save';

  @override
  String get ruleScreenResetRulesButton => 'Reset Rules';

  @override
  String get ruleScreenTotalPointsHint =>
      '“Total score” - Specify the point at which a game should end. If a player hits this value exactly with his score, then the rule “Exactly 100” comes into effect. If it is higher, the game is over.';

  @override
  String get ruleScreenKamikazeHint =>
      'Rule: “Kamikaze” - If a player ends a round with two 12\'s and two 13\'s, all other players receive 50 points and the Kamikaze player 0. Here you can set the number of points at which “Kamikaze” should take effect.';

  @override
  String get ruleScreenRoundWinnerHint =>
      'Rule: “Score” - The player who wins the round receives 0 points. If this rule is deactivated, the round winner receives the number of points with which he won.';

  @override
  String get ruleScreenExactly100Hint =>
      'Rule: “Exactly 100” - If a player hits the total number of points, their score is reduced to 50 points. If it is higher, the game is over. You can adjust the value at which this rule comes into effect by editing the total score.';

  @override
  String get ruleScreenScoreSection => 'Score Limits';

  @override
  String get ruleScreenMechanicsSection => 'Game Mechanics';

  @override
  String get ruleScreenTotalPointsDescription =>
      'The game ends as soon as a player reaches this score.';

  @override
  String get ruleScreenKamikazeDescription =>
      'Special rule: If a player reaches exactly this score at the end, something special happens.';

  @override
  String get ruleScreenZeroPointsDescription => 'Rewards winning a round.';

  @override
  String get ruleScreenPrecisionLandingDescription =>
      'A chance for a comeback.';

  @override
  String get ruleScreenPointsSuffix => 'pts';

  @override
  String get ruleScreenInfoCard =>
      'These rules apply to all active players in this round. Changes during a game can lead to unexpected score calculations.';

  @override
  String get developerModeToggled => 'Developermode toggled';

  @override
  String get aboutScreenTitle => 'About the app';

  @override
  String get aboutScreenSendButton => 'Send';

  @override
  String get aboutScreenTextAreaLabel => 'Your Message';

  @override
  String get aboutScreenSuccess => 'Thanks! Your feedback was send.';

  @override
  String get aboutScreenTextAreaDescription =>
      'Do you like the App? I would love to get a review!';

  @override
  String get aboutScreenText =>
      'I´ve created this app to make the game experience of the CABO Card game even better.';

  @override
  String get aboutScreenRatingButton => 'Rate';

  @override
  String get aboutScreenFeedbackTitle => 'Something missing?';

  @override
  String get aboutScreenFeedbackLabel => 'Your Message';

  @override
  String get aboutScreenFeedbackHint => 'What could we improve?';

  @override
  String get aboutScreenFeedbackButton => 'Send feedback';

  @override
  String get aboutScreenFeedbackAddImage => 'Attach image';

  @override
  String get aboutScreenFeedbackChangeImage => 'Change image';

  @override
  String get aboutScreenFeedbackSuccess => 'Thanks for sharing your feedback!';

  @override
  String get aboutScreenFeedbackError => 'Error sending feedback.';

  @override
  String get aboutScreenRatingHeadline => 'Do you like the app?';

  @override
  String get aboutScreenRatingDescription =>
      'I would be thrilled about a review in the store! It helps Cabo Board to grow.';

  @override
  String get aboutScreenFeedbackSubtitle => 'Let me know!';

  @override
  String get aboutScreenEmailLabel => 'Email (optional)';

  @override
  String get aboutScreenEmailHint => 'Your email address';

  @override
  String get aboutScreenEmailInvalid => 'Please enter a valid email address.';

  @override
  String get aboutScreenFeedbackRequired => 'Please enter a message.';

  @override
  String get aboutScreenFunFact =>
      'Did you know? The word \"Cabo\" means \"end\" in Spanish – exactly what you call out when you want to win!';

  @override
  String get rateAppTitle => 'Rate This App';

  @override
  String get rateAppDescription =>
      'How would you rate your experience with Cabo Board?';

  @override
  String get feedbackLabel => 'Your Feedback (Optional)';

  @override
  String get submitRating => 'Submit';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get winnerDialogTitle => 'Game Finshed!';

  @override
  String get hasWonText => 'has won!';

  @override
  String get withPointsText => 'with';

  @override
  String get pointsText => 'points';

  @override
  String get okButton => 'OK';

  @override
  String get endGameRankingTitle => 'Ranking';

  @override
  String get endGameBackToMenu => 'Back to menu';

  @override
  String get endGameDurationLabel => 'Game duration';

  @override
  String get endGameDurationUnitMinutes => 'min';

  @override
  String get endGameDurationUnitHours => 'h';

  @override
  String get endGameRoundsLabel => 'Rounds';

  @override
  String get endGameRoundsUnit => 'Total';

  @override
  String get endGameDetailedTitle => 'Detailed stats';

  @override
  String get endGameStatTotal => 'Total';

  @override
  String get endGameStatCaboZero => 'Cabo-0';

  @override
  String get endGameStatPenalty => 'Penalty';

  @override
  String get endGameStatAverage => 'Avg / Rd';

  @override
  String get endGamePointsShort => 'pts';

  @override
  String get endGameHighlightsTitle => 'Game highlights';

  @override
  String get endGameHighlightBestRound => 'Best round (low score)';

  @override
  String get endGameHighlightTotalSuffix => 'total';

  @override
  String get endGameRoundLabel => 'Round';

  @override
  String get endGameHighlightLongestStreak => 'Longest win streak';

  @override
  String get endGameHighlightStreakSuffix => 'rounds in a row';

  @override
  String get endGameStreakWinTitle => 'Win streak';

  @override
  String get endGameStreakDurationTitle => 'Long game';

  @override
  String get streakTitle => 'Streaks';

  @override
  String get streakFiveRoundsWon => 'A Player had a 5 Round Win Streak.';

  @override
  String get streakSevenRoundsWon => 'A Player had a 7 Round Win Streak.';

  @override
  String get streakTenRoundsWon => 'A Player had a 10 Round Win Streak.';

  @override
  String get streakOneHourGame => 'Game Time Over 1 Hour';

  @override
  String get streakOneAndHalfHourGame => 'Game Time Over 1 Hour 30 Minutes';

  @override
  String get streakTwoHourGame => 'Game Time Over 2 Hour';

  @override
  String get designSectionTitle => 'Design';

  @override
  String get designSectionSubtitle => 'Choose how the app looks';

  @override
  String get designModern => 'Modern';

  @override
  String get designClassic => 'Classic';

  @override
  String get designModernDescription => 'The light, modern look.';

  @override
  String get designClassicDescription =>
      'The original dark-green look with background image.';
}
