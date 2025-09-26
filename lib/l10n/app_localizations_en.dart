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
  String get playerAmountDialogTitle => 'Player Amount';

  @override
  String get continueText => 'Continue';

  @override
  String get loadedOwnRules => 'Own rules loaded.';

  @override
  String get playerNames => 'Player Names';

  @override
  String get start => 'Start';

  @override
  String get dialogPointsLabel => 'Points';

  @override
  String get statsCardRound => 'Round';

  @override
  String get statsCardTime => 'Play time';

  @override
  String get finishCurrentGame => 'Do you really want to finish the game?';

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
  String get enterDialogButton => 'Save';

  @override
  String get enterPointsDialogTitle => 'Enter points';

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
  String get authScreenSignInToPublish => 'Sign up to publish your game.';

  @override
  String get authScreenSignInWithGoogle => 'Log in with Google';

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
  String get aboutScreenTitle => 'About';

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
  String get aboutScreenFeedbackTitle => 'Something missing? - Let me know!';

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
}
