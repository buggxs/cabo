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

  /// No description provided for @menuEntrySettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuEntrySettings;

  /// No description provided for @settingsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsScreenTitle;

  /// No description provided for @mainMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your digital scorepad for the physical card game.'**
  String get mainMenuSubtitle;

  /// No description provided for @mainMenuStartBoardDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a scoreboard for your game with friends in person.'**
  String get mainMenuStartBoardDescription;

  /// No description provided for @mainMenuJoinBoardDescription.
  ///
  /// In en, this message translates to:
  /// **'Join an existing game to sync points with other players.'**
  String get mainMenuJoinBoardDescription;

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

  /// No description provided for @choosePlayersTitle.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get choosePlayersTitle;

  /// No description provided for @choosePlayersHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Who\'s playing today?'**
  String get choosePlayersHeroTitle;

  /// No description provided for @recentPlayerGroups.
  ///
  /// In en, this message translates to:
  /// **'Recent groups'**
  String get recentPlayerGroups;

  /// No description provided for @addPlayer.
  ///
  /// In en, this message translates to:
  /// **'Add another player'**
  String get addPlayer;

  /// No description provided for @playerLabelPrefix.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get playerLabelPrefix;

  /// No description provided for @playerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter name...'**
  String get playerNameHint;

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

  /// No description provided for @statsNavEndGame.
  ///
  /// In en, this message translates to:
  /// **'End Game'**
  String get statsNavEndGame;

  /// No description provided for @statsNavRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get statsNavRules;

  /// No description provided for @statsNavOnline.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get statsNavOnline;

  /// No description provided for @statsNavShare.
  ///
  /// In en, this message translates to:
  /// **'Share game'**
  String get statsNavShare;

  /// No description provided for @finishCurrentGame.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to finish the game?'**
  String get finishCurrentGame;

  /// No description provided for @finishCurrentGamePublic.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to finish the game? The game will be finished for all players.'**
  String get finishCurrentGamePublic;

  /// No description provided for @leaveCurrentGame.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to leave the game? The other players will keep playing.'**
  String get leaveCurrentGame;

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

  /// No description provided for @announcementDialogOkayButton.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get announcementDialogOkayButton;

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

  /// No description provided for @dialogRoundFinishedTitle.
  ///
  /// In en, this message translates to:
  /// **'Round finished!'**
  String get dialogRoundFinishedTitle;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @dialogEnterPoints.
  ///
  /// In en, this message translates to:
  /// **'Enter points'**
  String get dialogEnterPoints;

  /// No description provided for @dialogPointsRoundFinished.
  ///
  /// In en, this message translates to:
  /// **'Round {round} finished'**
  String dialogPointsRoundFinished(int round);

  /// No description provided for @dialogKeypadNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get dialogKeypadNext;

  /// No description provided for @dialogKeypadDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get dialogKeypadDone;

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

  /// No description provided for @authScreenSignInHeadline.
  ///
  /// In en, this message translates to:
  /// **'Ready for your next adventure?'**
  String get authScreenSignInHeadline;

  /// No description provided for @authScreenSignInToPublish.
  ///
  /// In en, this message translates to:
  /// **'Sign up to publish your game.'**
  String get authScreenSignInToPublish;

  /// No description provided for @authScreenSignInPrivacyHint.
  ///
  /// In en, this message translates to:
  /// **'Safe and fast. We never share your private data.'**
  String get authScreenSignInPrivacyHint;

  /// No description provided for @authScreenSignInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Log in with Google'**
  String get authScreenSignInWithGoogle;

  /// No description provided for @authScreenSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed. Please try again.'**
  String get authScreenSignInFailed;

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

  /// No description provided for @joinGameScreenGameAlreadyFinished.
  ///
  /// In en, this message translates to:
  /// **'This game has already finished and can no longer be joined.'**
  String get joinGameScreenGameAlreadyFinished;

  /// No description provided for @joinGameScreenScanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get joinGameScreenScanQrCode;

  /// No description provided for @joinGameScreenEnterIdInstead.
  ///
  /// In en, this message translates to:
  /// **'Enter ID instead'**
  String get joinGameScreenEnterIdInstead;

  /// No description provided for @joinGameScreenGameIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Game ID (e.g. cabo-123-xyz)'**
  String get joinGameScreenGameIdLabel;

  /// No description provided for @joinGameScreenSearchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get joinGameScreenSearchButton;

  /// No description provided for @joinGameScreenEnterIdToJoin.
  ///
  /// In en, this message translates to:
  /// **'Enter the game ID to join a game.'**
  String get joinGameScreenEnterIdToJoin;

  /// No description provided for @joinGameScreenOrDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get joinGameScreenOrDivider;

  /// No description provided for @joinGameScreenManualLabel.
  ///
  /// In en, this message translates to:
  /// **'Game ID'**
  String get joinGameScreenManualLabel;

  /// No description provided for @joinGameScreenSearchGameButton.
  ///
  /// In en, this message translates to:
  /// **'Search game'**
  String get joinGameScreenSearchGameButton;

  /// No description provided for @joinGameScreenJoinButton.
  ///
  /// In en, this message translates to:
  /// **'Join game'**
  String get joinGameScreenJoinButton;

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

  /// No description provided for @historyScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Game History'**
  String get historyScreenTitle;

  /// No description provided for @historyScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your adventures at the kitchen table'**
  String get historyScreenSubtitle;

  /// No description provided for @historyScreenStreaksActive.
  ///
  /// In en, this message translates to:
  /// **'Streaks active'**
  String get historyScreenStreaksActive;

  /// No description provided for @historyScreenDaysShort.
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get historyScreenDaysShort;

  /// No description provided for @historyScreenHoursShort.
  ///
  /// In en, this message translates to:
  /// **'hrs'**
  String get historyScreenHoursShort;

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

  /// No description provided for @ruleScreenScoreSection.
  ///
  /// In en, this message translates to:
  /// **'Score Limits'**
  String get ruleScreenScoreSection;

  /// No description provided for @ruleScreenMechanicsSection.
  ///
  /// In en, this message translates to:
  /// **'Game Mechanics'**
  String get ruleScreenMechanicsSection;

  /// No description provided for @ruleScreenTotalPointsDescription.
  ///
  /// In en, this message translates to:
  /// **'The game ends as soon as a player reaches this score.'**
  String get ruleScreenTotalPointsDescription;

  /// No description provided for @ruleScreenKamikazeDescription.
  ///
  /// In en, this message translates to:
  /// **'Special rule: If a player reaches exactly this score at the end, something special happens.'**
  String get ruleScreenKamikazeDescription;

  /// No description provided for @ruleScreenZeroPointsDescription.
  ///
  /// In en, this message translates to:
  /// **'Rewards winning a round.'**
  String get ruleScreenZeroPointsDescription;

  /// No description provided for @ruleScreenPrecisionLandingDescription.
  ///
  /// In en, this message translates to:
  /// **'A chance for a comeback.'**
  String get ruleScreenPrecisionLandingDescription;

  /// No description provided for @ruleScreenPointsSuffix.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get ruleScreenPointsSuffix;

  /// No description provided for @ruleScreenInfoCard.
  ///
  /// In en, this message translates to:
  /// **'These rules apply to all active players in this round. Changes during a game can lead to unexpected score calculations.'**
  String get ruleScreenInfoCard;

  /// No description provided for @developerModeToggled.
  ///
  /// In en, this message translates to:
  /// **'Developermode toggled'**
  String get developerModeToggled;

  /// No description provided for @aboutScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
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
  /// **'Something missing?'**
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

  /// No description provided for @aboutScreenRatingHeadline.
  ///
  /// In en, this message translates to:
  /// **'Do you like the app?'**
  String get aboutScreenRatingHeadline;

  /// No description provided for @aboutScreenRatingDescription.
  ///
  /// In en, this message translates to:
  /// **'I would be thrilled about a review in the store! It helps Cabo Board to grow.'**
  String get aboutScreenRatingDescription;

  /// No description provided for @aboutScreenFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let me know!'**
  String get aboutScreenFeedbackSubtitle;

  /// No description provided for @aboutScreenEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get aboutScreenEmailLabel;

  /// No description provided for @aboutScreenEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Your email address'**
  String get aboutScreenEmailHint;

  /// No description provided for @aboutScreenEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get aboutScreenEmailInvalid;

  /// No description provided for @aboutScreenFeedbackRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a message.'**
  String get aboutScreenFeedbackRequired;

  /// No description provided for @aboutScreenFunFact.
  ///
  /// In en, this message translates to:
  /// **'Did you know? The word \"Cabo\" means \"end\" in Spanish – exactly what you call out when you want to win!'**
  String get aboutScreenFunFact;

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

  /// No description provided for @endGameRankingTitle.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get endGameRankingTitle;

  /// No description provided for @endGameBackToMenu.
  ///
  /// In en, this message translates to:
  /// **'Back to menu'**
  String get endGameBackToMenu;

  /// No description provided for @endGameDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Game duration'**
  String get endGameDurationLabel;

  /// No description provided for @endGameDurationUnitMinutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get endGameDurationUnitMinutes;

  /// No description provided for @endGameDurationUnitHours.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get endGameDurationUnitHours;

  /// No description provided for @endGameRoundsLabel.
  ///
  /// In en, this message translates to:
  /// **'Rounds'**
  String get endGameRoundsLabel;

  /// No description provided for @endGameRoundsUnit.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get endGameRoundsUnit;

  /// No description provided for @endGameDetailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Detailed stats'**
  String get endGameDetailedTitle;

  /// No description provided for @endGameStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get endGameStatTotal;

  /// No description provided for @endGameStatCaboZero.
  ///
  /// In en, this message translates to:
  /// **'Cabo-0'**
  String get endGameStatCaboZero;

  /// No description provided for @endGameStatPenalty.
  ///
  /// In en, this message translates to:
  /// **'Penalty'**
  String get endGameStatPenalty;

  /// No description provided for @endGameStatAverage.
  ///
  /// In en, this message translates to:
  /// **'Avg / Rd'**
  String get endGameStatAverage;

  /// No description provided for @endGamePointsShort.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get endGamePointsShort;

  /// No description provided for @endGameHighlightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Game highlights'**
  String get endGameHighlightsTitle;

  /// No description provided for @endGameHighlightBestRound.
  ///
  /// In en, this message translates to:
  /// **'Best round (low score)'**
  String get endGameHighlightBestRound;

  /// No description provided for @endGameHighlightTotalSuffix.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get endGameHighlightTotalSuffix;

  /// No description provided for @endGameRoundLabel.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get endGameRoundLabel;

  /// No description provided for @endGameHighlightLongestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest win streak'**
  String get endGameHighlightLongestStreak;

  /// No description provided for @endGameHighlightStreakSuffix.
  ///
  /// In en, this message translates to:
  /// **'rounds in a row'**
  String get endGameHighlightStreakSuffix;

  /// No description provided for @endGameStreakWinTitle.
  ///
  /// In en, this message translates to:
  /// **'Win streak'**
  String get endGameStreakWinTitle;

  /// No description provided for @endGameStreakDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Long game'**
  String get endGameStreakDurationTitle;

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

  /// No description provided for @designSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get designSectionTitle;

  /// No description provided for @designSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how the app looks'**
  String get designSectionSubtitle;

  /// No description provided for @designModern.
  ///
  /// In en, this message translates to:
  /// **'Modern'**
  String get designModern;

  /// No description provided for @designClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get designClassic;

  /// No description provided for @designModernDescription.
  ///
  /// In en, this message translates to:
  /// **'The light, modern look.'**
  String get designModernDescription;

  /// No description provided for @designClassicDescription.
  ///
  /// In en, this message translates to:
  /// **'The original dark-green look with background image.'**
  String get designClassicDescription;
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
