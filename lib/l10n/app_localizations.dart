import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @gameName.
  ///
  /// In en, this message translates to:
  /// **'CABO'**
  String get gameName;

  /// No description provided for @gameSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get gameSubTitle;

  /// No description provided for @menuEntryTrackStats.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get menuEntryTrackStats;

  /// No description provided for @menuEntryGameHistory.
  ///
  /// In en, this message translates to:
  /// **'Game History'**
  String get menuEntryGameHistory;

  /// No description provided for @menuEntryJoinGame.
  ///
  /// In en, this message translates to:
  /// **'Join Game'**
  String get menuEntryJoinGame;

  /// No description provided for @menuEntryGameRules.
  ///
  /// In en, this message translates to:
  /// **'Game Rules'**
  String get menuEntryGameRules;

  /// No description provided for @menuEntryGameAboutScreen.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menuEntryGameAboutScreen;

  /// No description provided for @playerAmountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Player Amount'**
  String get playerAmountDialogTitle;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @loadedOwnRules.
  ///
  /// In en, this message translates to:
  /// **'Own rules loaded.'**
  String get loadedOwnRules;

  /// No description provided for @playerNames.
  ///
  /// In en, this message translates to:
  /// **'Player Names'**
  String get playerNames;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @dialogPointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get dialogPointsLabel;

  /// No description provided for @statsCardRound.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get statsCardRound;

  /// No description provided for @statsCardTime.
  ///
  /// In en, this message translates to:
  /// **'Play time'**
  String get statsCardTime;

  /// No description provided for @finishCurrentGame.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to finish the game?'**
  String get finishCurrentGame;

  /// No description provided for @finishGameDialogButton.
  ///
  /// In en, this message translates to:
  /// **'Yes, finish!'**
  String get finishGameDialogButton;

  /// No description provided for @leaveGameDialogButton.
  ///
  /// In en, this message translates to:
  /// **'Leave game.'**
  String get leaveGameDialogButton;

  /// No description provided for @continueGameDialogButton.
  ///
  /// In en, this message translates to:
  /// **'No, keep playing.'**
  String get continueGameDialogButton;

  /// No description provided for @dialogTextRoundFinishedBy.
  ///
  /// In en, this message translates to:
  /// **'Who finished the round?'**
  String get dialogTextRoundFinishedBy;

  /// No description provided for @dialogTitleLoadFinishedGame.
  ///
  /// In en, this message translates to:
  /// **'Not Finished Game'**
  String get dialogTitleLoadFinishedGame;

  /// No description provided for @dialogTextLoadFinishedGame.
  ///
  /// In en, this message translates to:
  /// **'You have not finished the last game, should it be loaded?'**
  String get dialogTextLoadFinishedGame;

  /// No description provided for @loadGameDialogButton.
  ///
  /// In en, this message translates to:
  /// **'Yes, load game!'**
  String get loadGameDialogButton;

  /// No description provided for @notLoadGameDialogButton.
  ///
  /// In en, this message translates to:
  /// **'No, do not load.'**
  String get notLoadGameDialogButton;

  /// No description provided for @enterDialogButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get enterDialogButton;

  /// No description provided for @enterPointsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter points'**
  String get enterPointsDialogTitle;

  /// No description provided for @publishDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish Game'**
  String get publishDialogTitle;

  /// No description provided for @publishDialogReadyToPublish.
  ///
  /// In en, this message translates to:
  /// **'Your game is ready to be published.'**
  String get publishDialogReadyToPublish;

  /// No description provided for @publishDialogLoading.
  ///
  /// In en, this message translates to:
  /// **'Your game will be published...'**
  String get publishDialogLoading;

  /// No description provided for @publishDialogGamePublished.
  ///
  /// In en, this message translates to:
  /// **'Your game is now public'**
  String get publishDialogGamePublished;

  /// No description provided for @publishDialogJoinedGame.
  ///
  /// In en, this message translates to:
  /// **'You are in a public game'**
  String get publishDialogJoinedGame;

  /// No description provided for @publishDialogFriendsCanJoin.
  ///
  /// In en, this message translates to:
  /// **'Others can join the game using this QR code:'**
  String get publishDialogFriendsCanJoin;

  /// No description provided for @publishDialogPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish game'**
  String get publishDialogPublish;

  /// No description provided for @publishDialogFailedToPublish.
  ///
  /// In en, this message translates to:
  /// **'Game could not be published.'**
  String get publishDialogFailedToPublish;

  /// No description provided for @authScreenSignInToPublish.
  ///
  /// In en, this message translates to:
  /// **'Sign up to publish your game.'**
  String get authScreenSignInToPublish;

  /// No description provided for @authScreenSignInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Log in with Google'**
  String get authScreenSignInWithGoogle;

  /// No description provided for @authScreenSignInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Log in/register with e-mail'**
  String get authScreenSignInWithEmail;

  /// No description provided for @authScreenEmail.
  ///
  /// In en, this message translates to:
  /// **'E-Mail'**
  String get authScreenEmail;

  /// No description provided for @authScreenPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authScreenPassword;

  /// No description provided for @authScreenPasswordRepeat.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authScreenPasswordRepeat;

  /// No description provided for @authScreenSignIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get authScreenSignIn;

  /// No description provided for @authScreenAlreadyAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get authScreenAlreadyAccount;

  /// No description provided for @authScreenRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authScreenRegister;

  /// No description provided for @authScreenPasswortMissmatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get authScreenPasswortMissmatch;

  /// No description provided for @authScreenStartRegister.
  ///
  /// In en, this message translates to:
  /// **'No account yet? Register'**
  String get authScreenStartRegister;

  /// No description provided for @authScreenBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get authScreenBack;

  /// No description provided for @joinGameScreenScanToJoin.
  ///
  /// In en, this message translates to:
  /// **'Scan a QR code to join a game.'**
  String get joinGameScreenScanToJoin;

  /// No description provided for @joinGameScreenGameFound.
  ///
  /// In en, this message translates to:
  /// **'Game found!'**
  String get joinGameScreenGameFound;

  /// No description provided for @joinGameScreenGameRounds.
  ///
  /// In en, this message translates to:
  /// **'Rounds'**
  String get joinGameScreenGameRounds;

  /// No description provided for @joinGameScreenGamePoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get joinGameScreenGamePoints;

  /// No description provided for @joinGameScreenLoadingStatus.
  ///
  /// In en, this message translates to:
  /// **'A game ID was recognized'**
  String get joinGameScreenLoadingStatus;

  /// No description provided for @joinGameScreenSearchingGame.
  ///
  /// In en, this message translates to:
  /// **'Search for the game...'**
  String get joinGameScreenSearchingGame;

  /// No description provided for @joinGameScreenGameNotFound.
  ///
  /// In en, this message translates to:
  /// **'Game could not be found.'**
  String get joinGameScreenGameNotFound;

  /// No description provided for @historyScreenHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get historyScreenHours;

  /// No description provided for @historyScreenDays.
  ///
  /// In en, this message translates to:
  /// **'Day/s'**
  String get historyScreenDays;

  /// No description provided for @historyScreenMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get historyScreenMinutes;

  /// No description provided for @historyScreenGamesCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get historyScreenGamesCardTitle;

  /// No description provided for @historyScreenGameTimeCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Game Time'**
  String get historyScreenGameTimeCardTitle;

  /// No description provided for @historyScreenPlayedRoundsCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Played Rounds'**
  String get historyScreenPlayedRoundsCardTitle;

  /// No description provided for @historyScreenTotalPointsTitle.
  ///
  /// In en, this message translates to:
  /// **'Total amount of collected Points'**
  String get historyScreenTotalPointsTitle;

  /// No description provided for @ruleScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get ruleScreenTitle;

  /// No description provided for @ruleScreenKamikazePointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Kamikaze Points'**
  String get ruleScreenKamikazePointsLabel;

  /// No description provided for @ruleScreenTotalGamePointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total score'**
  String get ruleScreenTotalGamePointsLabel;

  /// No description provided for @ruleScreenZeroPointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Round Winner get 0 Points'**
  String get ruleScreenZeroPointsLabel;

  /// No description provided for @ruleScreenPrecisionLandingLabel.
  ///
  /// In en, this message translates to:
  /// **'Exactly 100'**
  String get ruleScreenPrecisionLandingLabel;

  /// No description provided for @ruleScreenSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get ruleScreenSaveButton;

  /// No description provided for @ruleScreenResetRulesButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Rules'**
  String get ruleScreenResetRulesButton;

  /// No description provided for @ruleScreenTotalPointsHint.
  ///
  /// In en, this message translates to:
  /// **'“Total score” - Specify the point at which a game should end. If a player hits this value exactly with his score, then the rule “Exactly 100” comes into effect. If it is higher, the game is over.'**
  String get ruleScreenTotalPointsHint;

  /// No description provided for @ruleScreenKamikazeHint.
  ///
  /// In en, this message translates to:
  /// **'Rule: “Kamikaze” - If a player ends a round with two 12\'s and two 13\'s, all other players receive 50 points and the Kamikaze player 0. Here you can set the number of points at which “Kamikaze” should take effect.'**
  String get ruleScreenKamikazeHint;

  /// No description provided for @ruleScreenRoundWinnerHint.
  ///
  /// In en, this message translates to:
  /// **'Rule: “Score” - The player who wins the round receives 0 points. If this rule is deactivated, the round winner receives the number of points with which he won.'**
  String get ruleScreenRoundWinnerHint;

  /// No description provided for @ruleScreenExactly100Hint.
  ///
  /// In en, this message translates to:
  /// **'Rule: “Exactly 100” - If a player hits the total number of points, their score is reduced to 50 points. If it is higher, the game is over. You can adjust the value at which this rule comes into effect by editing the total score.'**
  String get ruleScreenExactly100Hint;

  /// No description provided for @aboutScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutScreenTitle;

  /// No description provided for @aboutScreenSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get aboutScreenSendButton;

  /// No description provided for @aboutScreenTextAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Message'**
  String get aboutScreenTextAreaLabel;

  /// No description provided for @aboutScreenSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thanks! Your feedback was send.'**
  String get aboutScreenSuccess;

  /// No description provided for @aboutScreenTextAreaDescription.
  ///
  /// In en, this message translates to:
  /// **'Do you like the App? I would love to get a review!'**
  String get aboutScreenTextAreaDescription;

  /// No description provided for @aboutScreenText.
  ///
  /// In en, this message translates to:
  /// **'I´ve created this app to make the game experience of the CABO Card game even better.'**
  String get aboutScreenText;

  /// No description provided for @aboutScreenRatingButton.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get aboutScreenRatingButton;

  /// No description provided for @aboutScreenFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Something missing? - Let me know!'**
  String get aboutScreenFeedbackTitle;

  /// No description provided for @aboutScreenFeedbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Message'**
  String get aboutScreenFeedbackLabel;

  /// No description provided for @aboutScreenFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'What could we improve?'**
  String get aboutScreenFeedbackHint;

  /// No description provided for @aboutScreenFeedbackButton.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get aboutScreenFeedbackButton;

  /// No description provided for @aboutScreenFeedbackAddImage.
  ///
  /// In en, this message translates to:
  /// **'Attach image'**
  String get aboutScreenFeedbackAddImage;

  /// No description provided for @aboutScreenFeedbackChangeImage.
  ///
  /// In en, this message translates to:
  /// **'Change image'**
  String get aboutScreenFeedbackChangeImage;

  /// No description provided for @aboutScreenFeedbackSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thanks for sharing your feedback!'**
  String get aboutScreenFeedbackSuccess;

  /// No description provided for @aboutScreenFeedbackError.
  ///
  /// In en, this message translates to:
  /// **'Error sending feedback.'**
  String get aboutScreenFeedbackError;

  /// No description provided for @rateAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate This App'**
  String get rateAppTitle;

  /// No description provided for @rateAppDescription.
  ///
  /// In en, this message translates to:
  /// **'How would you rate your experience with Cabo Board?'**
  String get rateAppDescription;

  /// No description provided for @feedbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Feedback (Optional)'**
  String get feedbackLabel;

  /// No description provided for @submitRating.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitRating;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @winnerDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Game Finshed!'**
  String get winnerDialogTitle;

  /// No description provided for @hasWonText.
  ///
  /// In en, this message translates to:
  /// **'has won!'**
  String get hasWonText;

  /// No description provided for @withPointsText.
  ///
  /// In en, this message translates to:
  /// **'with'**
  String get withPointsText;

  /// No description provided for @pointsText.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get pointsText;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @streakTitle.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get streakTitle;

  /// No description provided for @streakFiveRoundsWon.
  ///
  /// In en, this message translates to:
  /// **'A Player had a 5 Round Win Streak.'**
  String get streakFiveRoundsWon;

  /// No description provided for @streakSevenRoundsWon.
  ///
  /// In en, this message translates to:
  /// **'A Player had a 7 Round Win Streak.'**
  String get streakSevenRoundsWon;

  /// No description provided for @streakTenRoundsWon.
  ///
  /// In en, this message translates to:
  /// **'A Player had a 10 Round Win Streak.'**
  String get streakTenRoundsWon;

  /// No description provided for @streakOneHourGame.
  ///
  /// In en, this message translates to:
  /// **'Game Time Over 1 Hour'**
  String get streakOneHourGame;

  /// No description provided for @streakOneAndHalfHourGame.
  ///
  /// In en, this message translates to:
  /// **'Game Time Over 1 Hour 30 Minutes'**
  String get streakOneAndHalfHourGame;

  /// No description provided for @streakTwoHourGame.
  ///
  /// In en, this message translates to:
  /// **'Game Time Over 2 Hour'**
  String get streakTwoHourGame;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
