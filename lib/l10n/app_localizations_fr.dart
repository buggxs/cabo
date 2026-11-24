// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get gameName => 'CABO';

  @override
  String get gameSubTitle => 'Board';

  @override
  String get menuEntryTrackStats => 'Nouvelle partie';

  @override
  String get menuEntryGameHistory => 'Historique';

  @override
  String get menuEntryJoinGame => 'Rejoindre une partie';

  @override
  String get menuEntryGameRules => 'Règles du jeu';

  @override
  String get menuEntryGameAboutScreen => 'À propos';

  @override
  String get menuEntrySettings => 'Paramètres';

  @override
  String get settingsScreenTitle => 'Paramètres';

  @override
  String get mainMenuSubtitle =>
      'Ta feuille de score numérique pour le vrai jeu de cartes.';

  @override
  String get mainMenuStartBoardDescription =>
      'Crée un tableau des scores pour ta partie entre amis autour de la table.';

  @override
  String get mainMenuJoinBoardDescription =>
      'Rejoins une partie existante pour synchroniser les points avec les autres joueurs.';

  @override
  String get playerAmountDialogTitle => 'Nombre de joueurs';

  @override
  String get continueText => 'Continuer';

  @override
  String get loadedOwnRules => 'Règles personnalisées chargées.';

  @override
  String get playerNames => 'Noms des joueurs';

  @override
  String get choosePlayersTitle => 'Joueurs';

  @override
  String get choosePlayersHeroTitle => 'Qui joue aujourd\'hui ?';

  @override
  String get recentPlayerGroups => 'Groupes récents';

  @override
  String get addPlayer => 'Ajouter un joueur';

  @override
  String get playerLabelPrefix => 'Joueur';

  @override
  String get playerNameHint => 'Saisis un nom...';

  @override
  String get start => 'Commencer';

  @override
  String get dialogPointsLabel => 'Points';

  @override
  String get statsCardRound => 'Manche';

  @override
  String get statsCardTime => 'Durée de jeu';

  @override
  String get statsNavEndGame => 'Terminer';

  @override
  String get statsNavRules => 'Règles';

  @override
  String get statsNavOnline => 'Publique';

  @override
  String get statsNavShare => 'Partager la partie';

  @override
  String get finishCurrentGame => 'Veux-tu vraiment terminer la partie ?';

  @override
  String get finishCurrentGamePublic =>
      'Veux-tu vraiment terminer la partie ? Elle sera terminée pour tous les joueurs.';

  @override
  String get leaveCurrentGame =>
      'Veux-tu vraiment quitter la partie ? Les autres joueurs continueront à jouer.';

  @override
  String get finishGameDialogButton => 'Oui, terminer !';

  @override
  String get leaveGameDialogButton => 'Quitter la partie.';

  @override
  String get continueGameDialogButton => 'Non, continuer.';

  @override
  String get dialogTextRoundFinishedBy => 'Qui a terminé la manche ?';

  @override
  String get dialogTitleLoadFinishedGame => 'Partie non terminée';

  @override
  String get dialogTextLoadFinishedGame =>
      'Tu n\'as pas terminé la dernière partie. Faut-il la charger ?';

  @override
  String get loadGameDialogButton => 'Oui, charger la partie !';

  @override
  String get notLoadGameDialogButton => 'Non, ne pas charger.';

  @override
  String get announcementDialogOkayButton => 'OK';

  @override
  String get enterDialogButton => 'Enregistrer';

  @override
  String get enterPointsDialogTitle => 'Saisir les points';

  @override
  String get dialogRoundFinishedTitle => 'Manche terminée !';

  @override
  String get dialogCancel => 'Annuler';

  @override
  String get dialogEnterPoints => 'Saisir les points';

  @override
  String dialogPointsRoundFinished(int round) {
    return 'Manche $round terminée';
  }

  @override
  String get dialogKeypadNext => 'Suivant';

  @override
  String get dialogKeypadDone => 'Terminé';

  @override
  String get publishDialogTitle => 'Publier la partie';

  @override
  String get publishDialogReadyToPublish =>
      'Ta partie est prête à être publiée.';

  @override
  String get publishDialogLoading => 'Publication de ta partie...';

  @override
  String get publishDialogGamePublished => 'Ta partie est maintenant publique';

  @override
  String get publishDialogJoinedGame => 'Tu es dans une partie publique';

  @override
  String get publishDialogFriendsCanJoin =>
      'Les autres peuvent rejoindre la partie avec ce code QR :';

  @override
  String get publishDialogPublish => 'Publier la partie';

  @override
  String get publishDialogNextSteps =>
      'Saisis les points après chaque manche — les autres joueurs les voient immédiatement.';

  @override
  String get publishDialogContinueToGame => 'Aller à la partie';

  @override
  String get publishDialogCodeStaysAvailable =>
      'Tu retrouves le code à tout moment via « Publique ».';

  @override
  String get publishDialogFailedToPublish =>
      'La partie n\'a pas pu être publiée.';

  @override
  String get authScreenSignInHeadline => 'Prêt pour ta prochaine aventure ?';

  @override
  String get authScreenSignInToPublish => 'Inscris-toi pour publier ta partie.';

  @override
  String get authScreenSignInPrivacyHint =>
      'Sûr et rapide. Nous ne partageons jamais tes données personnelles.';

  @override
  String get authScreenSignInWithGoogle => 'Se connecter avec Google';

  @override
  String get authScreenSignInFailed => 'La connexion a échoué. Réessaie.';

  @override
  String get authScreenSignInWithEmail => 'Connexion/inscription par e-mail';

  @override
  String get authScreenEmail => 'E-mail';

  @override
  String get authScreenPassword => 'Mot de passe';

  @override
  String get authScreenPasswordRepeat => 'Confirmer le mot de passe';

  @override
  String get authScreenSignIn => 'Se connecter';

  @override
  String get authScreenAlreadyAccount => 'Déjà un compte ? Se connecter';

  @override
  String get authScreenRegister => 'S\'inscrire';

  @override
  String get authScreenPasswortMissmatch =>
      'Les mots de passe ne correspondent pas.';

  @override
  String get authScreenStartRegister => 'Pas encore de compte ? S\'inscrire';

  @override
  String get authScreenBack => 'Retour';

  @override
  String get authScreenShowPassword => 'Afficher le mot de passe';

  @override
  String get authScreenHidePassword => 'Masquer le mot de passe';

  @override
  String get authScreenForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authScreenPasswordResetSent =>
      'Nous t\'avons envoyé un lien pour réinitialiser ton mot de passe.';

  @override
  String get verifyEmailUseOtherAccount => 'Utiliser une autre adresse';

  @override
  String get authScreenEmailAlreadyInUse =>
      'Un compte existe déjà pour cet e-mail.';

  @override
  String get authScreenLinkConflictHint =>
      'Connecte-toi pour utiliser ce compte. Les parties en ligne lancées sur cet appareil n\'y seront pas associées.';

  @override
  String get authScreenInvalidCredentials =>
      'E-mail ou mot de passe incorrect.';

  @override
  String get authScreenWeakPassword => 'Utilise au moins 8 caractères.';

  @override
  String get authScreenInvalidEmail => 'Saisis une adresse e-mail valide.';

  @override
  String get authScreenTooManyRequests =>
      'Trop de tentatives. Patiente un instant.';

  @override
  String get authScreenNetworkError => 'Pas de connexion. Réessaie.';

  @override
  String get authScreenEmailRequired => 'Saisis ton adresse e-mail.';

  @override
  String get authScreenPasswordRequired => 'Saisis un mot de passe.';

  @override
  String get verifyEmailTitle => 'Confirme ton e-mail';

  @override
  String verifyEmailDescription(String email) {
    return 'Nous avons envoyé un lien de confirmation à $email. Ouvre-le, puis reviens ici.';
  }

  @override
  String get authScreenMailSpamHint =>
      'Pas de mail ? Vérifie ton dossier spam et marque-le comme « non spam » — le prochain arrivera ainsi.';

  @override
  String get verifyEmailResend => 'Renvoyer';

  @override
  String verifyEmailResendIn(int seconds) {
    return 'Renvoyer dans $seconds s';
  }

  @override
  String get verifyEmailResent => 'Mail envoyé.';

  @override
  String get verifyEmailCheckNow => 'J\'ai confirmé';

  @override
  String get verifyEmailStillPending =>
      'Pas encore confirmé. Ouvre le lien dans le mail.';

  @override
  String get accountCardTitle => 'Compte';

  @override
  String get accountCardAnonymous => 'Tu joues sans compte';

  @override
  String get accountCardAnonymousHint =>
      'Inscris-toi pour publier des parties.';

  @override
  String get accountCardVerified => 'E-mail confirmé';

  @override
  String get accountCardUnverified => 'E-mail pas encore confirmé';

  @override
  String get accountCardSignOut => 'Se déconnecter';

  @override
  String get joinGameScreenScanToJoin =>
      'Scanne un code QR pour rejoindre une partie.';

  @override
  String get joinGameScreenGameFound => 'Partie trouvée !';

  @override
  String get joinGameScreenGameRounds => 'Manches';

  @override
  String get joinGameScreenGamePoints => 'Points';

  @override
  String get joinGameScreenLoadingStatus =>
      'Un identifiant de partie a été reconnu';

  @override
  String get joinGameScreenSearchingGame => 'Recherche de la partie...';

  @override
  String get joinGameScreenGameNotFound => 'La partie est introuvable.';

  @override
  String get joinGameScreenGameAlreadyFinished =>
      'Cette partie est déjà terminée et ne peut plus être rejointe.';

  @override
  String get joinGameScreenScanQrCode => 'Scanner le code QR';

  @override
  String get joinGameScreenEnterIdInstead => 'Saisir l\'ID';

  @override
  String get joinGameScreenGameIdLabel => 'ID de partie (ex. cabo-123-xyz)';

  @override
  String get joinGameScreenSearchButton => 'Rechercher';

  @override
  String get joinGameScreenEnterIdToJoin =>
      'Saisis l\'ID de la partie pour la rejoindre.';

  @override
  String get joinGameScreenOrDivider => 'ou';

  @override
  String get joinGameScreenManualLabel => 'ID de partie';

  @override
  String get joinGameScreenSearchGameButton => 'Rechercher la partie';

  @override
  String get joinGameScreenJoinButton => 'Rejoindre la partie';

  @override
  String get historyScreenHours => 'Heures';

  @override
  String get historyScreenDays => 'Jours';

  @override
  String get historyScreenMinutes => 'Minutes';

  @override
  String get historyScreenGamesCardTitle => 'Parties';

  @override
  String get historyScreenGameTimeCardTitle => 'Temps de jeu';

  @override
  String get historyScreenPlayedRoundsCardTitle => 'Manches jouées';

  @override
  String get historyScreenTotalPointsTitle => 'Points cumulés';

  @override
  String get historyScreenTitle => 'Historique';

  @override
  String get historyScreenSubtitle => 'Tes aventures autour de la table';

  @override
  String get historyScreenStreaksActive => 'Séries actives';

  @override
  String get historyScreenDaysShort => 'j';

  @override
  String get historyScreenHoursShort => 'h';

  @override
  String get ruleScreenTitle => 'Règles';

  @override
  String get ruleScreenKamikazePointsLabel => 'Points Kamikaze';

  @override
  String get ruleScreenTotalGamePointsLabel => 'Score total';

  @override
  String get ruleScreenZeroPointsLabel => 'Gagnant de manche : 0 point';

  @override
  String get ruleScreenPrecisionLandingLabel => 'Pile 100';

  @override
  String get ruleScreenSaveButton => 'Enregistrer';

  @override
  String get ruleScreenResetRulesButton => 'Réinitialiser les règles';

  @override
  String get ruleScreenTotalPointsHint =>
      '« Score total » — Définis à partir de quel score la partie se termine. Si un joueur atteint exactement cette valeur, la règle « Pile 100 » s\'applique. S\'il la dépasse, la partie est terminée.';

  @override
  String get ruleScreenKamikazeHint =>
      'Règle « Kamikaze » — Si un joueur termine une manche avec cette valeur, tous les autres reçoivent les points Kamikaze et le joueur Kamikaze 0. Ici, tu règles la valeur à partir de laquelle « Kamikaze » s\'applique.';

  @override
  String get ruleScreenRoundWinnerHint =>
      'Règle « Score » — Le joueur qui gagne la manche marque 0 point. Si cette règle est désactivée, le gagnant marque les points avec lesquels il a gagné.';

  @override
  String get ruleScreenExactly100Hint =>
      'Règle « Pile 100 » — Si un joueur atteint exactement le score total, son score est divisé par deux. S\'il le dépasse, la partie est terminée. Tu peux ajuster cette valeur en modifiant le score total.';

  @override
  String get ruleScreenScoreSection => 'Limites de score';

  @override
  String get ruleScreenMechanicsSection => 'Mécaniques de jeu';

  @override
  String get ruleScreenTotalPointsDescription =>
      'La partie se termine dès qu\'un joueur dépasse ce score.';

  @override
  String get ruleScreenKamikazeDescription =>
      'Règle spéciale : qui termine une manche avec exactement ce score marque 0 — tous les autres reçoivent ce score. 0 désactive la règle.';

  @override
  String get ruleScreenZeroPointsDescription =>
      'Récompense la victoire d\'une manche : le gagnant marque 0 au lieu des points de sa main.';

  @override
  String get ruleScreenPrecisionLandingDescription =>
      'Une chance de revenir : qui atteint exactement le score total voit ses points divisés par deux.';

  @override
  String get roundBadgeKamikaze => 'KAMIKAZE';

  @override
  String get roundBadgeKamikazeTooltip =>
      'Manche Kamikaze : le joueur Kamikaze marque 0, tous les autres reçoivent les points Kamikaze.';

  @override
  String get roundBadgePenaltyTooltip =>
      'Cabo raté : 5 points de pénalité en plus de la main.';

  @override
  String get roundBadgePrecisionLandingTooltip =>
      'Pile dans le mille : le score a été ramené à la moitié du score total.';

  @override
  String get ruleScreenPointsSuffix => 'pts';

  @override
  String get ruleScreenInfoCard =>
      'Ces règles s\'appliquent à tous les joueurs actifs de cette manche. Les modifier en cours de partie peut entraîner des calculs de points inattendus.';

  @override
  String get developerModeToggled => 'Mode développeur modifié';

  @override
  String get aboutScreenTitle => 'À propos de l\'app';

  @override
  String get aboutScreenSendButton => 'Envoyer';

  @override
  String get aboutScreenTextAreaLabel => 'Ton message';

  @override
  String get aboutScreenSuccess => 'Merci ! Ton avis a été envoyé.';

  @override
  String get aboutScreenTextAreaDescription =>
      'Tu aimes l\'app ? Je serais ravi d\'avoir ton avis !';

  @override
  String get aboutScreenText =>
      'J\'ai créé cette app pour rendre l\'expérience du jeu de cartes CABO encore meilleure.';

  @override
  String get aboutScreenRatingButton => 'Noter';

  @override
  String get aboutScreenFeedbackTitle => 'Il manque quelque chose ?';

  @override
  String get aboutScreenFeedbackLabel => 'Ton message';

  @override
  String get aboutScreenFeedbackHint => 'Que pourrions-nous améliorer ?';

  @override
  String get aboutScreenFeedbackButton => 'Envoyer un avis';

  @override
  String get aboutScreenFeedbackAddImage => 'Joindre une image';

  @override
  String get aboutScreenFeedbackChangeImage => 'Changer l\'image';

  @override
  String get aboutScreenFeedbackSuccess => 'Merci pour ton avis !';

  @override
  String get aboutScreenFeedbackError => 'Erreur lors de l\'envoi.';

  @override
  String get aboutScreenRatingHeadline => 'Tu aimes l\'app ?';

  @override
  String get aboutScreenRatingDescription =>
      'Une note dans le store me ferait très plaisir ! Elle aide Cabo Board à grandir.';

  @override
  String get aboutScreenFeedbackSubtitle => 'Dis-le-moi !';

  @override
  String get aboutScreenEmailLabel => 'E-mail (facultatif)';

  @override
  String get aboutScreenEmailHint => 'Ton adresse e-mail';

  @override
  String get aboutScreenEmailInvalid => 'Saisis une adresse e-mail valide.';

  @override
  String get aboutScreenFeedbackRequired => 'Saisis un message.';

  @override
  String get aboutScreenFunFact =>
      'Le savais-tu ? Le mot « Cabo » signifie « fin » en espagnol — exactement ce que tu annonces quand tu veux gagner !';

  @override
  String get rateAppTitle => 'Note cette app';

  @override
  String get rateAppDescription =>
      'Comment évaluerais-tu ton expérience avec Cabo Board ?';

  @override
  String get feedbackLabel => 'Ton avis (facultatif)';

  @override
  String get submitRating => 'Envoyer';

  @override
  String get maybeLater => 'Plus tard';

  @override
  String get winnerDialogTitle => 'Partie terminée !';

  @override
  String get hasWonText => 'a gagné !';

  @override
  String get withPointsText => 'avec';

  @override
  String get pointsText => 'points';

  @override
  String get okButton => 'OK';

  @override
  String get endGameRankingTitle => 'Classement';

  @override
  String get endGameBackToMenu => 'Retour au menu';

  @override
  String get endGameDurationLabel => 'Durée de la partie';

  @override
  String get endGameDurationUnitMinutes => 'min';

  @override
  String get endGameDurationUnitHours => 'h';

  @override
  String get endGameRoundsLabel => 'Manches';

  @override
  String get endGameRoundsUnit => 'Total';

  @override
  String get endGameDetailedTitle => 'Statistiques détaillées';

  @override
  String get endGameStatTotal => 'Total';

  @override
  String get endGameStatCaboZero => 'Cabo-0';

  @override
  String get endGameStatPenalty => 'Pénalité';

  @override
  String get endGameStatAverage => 'Moy. / M';

  @override
  String get endGamePointsShort => 'pts';

  @override
  String get endGameHighlightsTitle => 'Temps forts';

  @override
  String get endGameHighlightBestRound => 'Meilleure manche (score bas)';

  @override
  String get endGameHighlightTotalSuffix => 'au total';

  @override
  String get endGameRoundLabel => 'Manche';

  @override
  String get endGameHighlightLongestStreak => 'Plus longue série de victoires';

  @override
  String endGameHighlightStreakRounds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count manches d\'affilée',
      one: '1 manche d\'affilée',
    );
    return '$_temp0';
  }

  @override
  String get endGameStreakWinTitle => 'Série de victoires';

  @override
  String get endGameStreakDurationTitle => 'Longue partie';

  @override
  String get streakTitle => 'Séries';

  @override
  String get streakFiveRoundsWon => 'Un joueur a gagné 5 manches d\'affilée.';

  @override
  String get streakSevenRoundsWon => 'Un joueur a gagné 7 manches d\'affilée.';

  @override
  String get streakTenRoundsWon => 'Un joueur a gagné 10 manches d\'affilée.';

  @override
  String get streakOneHourGame => 'Partie de plus d\'1 heure';

  @override
  String get streakOneAndHalfHourGame => 'Partie de plus d\'1 heure 30';

  @override
  String get streakTwoHourGame => 'Partie de plus de 2 heures';

  @override
  String get designSectionTitle => 'Design';

  @override
  String get designSectionSubtitle => 'Choisis l\'apparence de l\'app';

  @override
  String get designModern => 'Moderne';

  @override
  String get designClassic => 'Classique';

  @override
  String get designModernDescription => 'Le look clair et moderne.';

  @override
  String get designClassicDescription =>
      'Le look vert foncé d\'origine avec image de fond.';
}
