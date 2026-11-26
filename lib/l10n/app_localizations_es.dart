// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get gameName => 'CABO';

  @override
  String get gameSubTitle => 'Board';

  @override
  String get menuEntryTrackStats => 'Empezar partida';

  @override
  String get menuEntryGameHistory => 'Historial';

  @override
  String get menuEntryJoinGame => 'Unirse a partida';

  @override
  String get menuEntryGameRules => 'Reglas';

  @override
  String get menuEntryGameAboutScreen => 'Acerca de';

  @override
  String get menuEntrySettings => 'Ajustes';

  @override
  String get settingsScreenTitle => 'Ajustes';

  @override
  String get mainMenuSubtitle =>
      'Tu marcador digital para el juego de cartas real.';

  @override
  String get mainMenuStartBoardDescription =>
      'Crea un marcador para tu partida con amigos en persona.';

  @override
  String get mainMenuJoinBoardDescription =>
      'Únete a una partida existente para sincronizar los puntos con otros jugadores.';

  @override
  String get playerAmountDialogTitle => 'Número de jugadores';

  @override
  String get continueText => 'Continuar';

  @override
  String get loadedOwnRules => 'Reglas propias cargadas.';

  @override
  String get playerNames => 'Nombres de los jugadores';

  @override
  String get choosePlayersTitle => 'Jugadores';

  @override
  String get choosePlayersHeroTitle => '¿Quién juega hoy?';

  @override
  String get recentPlayerGroups => 'Grupos recientes';

  @override
  String get addPlayer => 'Añadir otro jugador';

  @override
  String get playerLabelPrefix => 'Jugador';

  @override
  String get playerNameHint => 'Introduce un nombre...';

  @override
  String get start => 'Empezar';

  @override
  String get dialogPointsLabel => 'Puntos';

  @override
  String get statsCardRound => 'Ronda';

  @override
  String get statsCardTime => 'Tiempo de juego';

  @override
  String get statsNavEndGame => 'Terminar partida';

  @override
  String get statsNavRules => 'Reglas';

  @override
  String get statsNavOnline => 'Pública';

  @override
  String get statsNavShare => 'Compartir partida';

  @override
  String get finishCurrentGame => '¿Seguro que quieres terminar la partida?';

  @override
  String get finishCurrentGamePublic =>
      '¿Seguro que quieres terminar la partida? La partida terminará para todos los jugadores.';

  @override
  String get leaveCurrentGame =>
      '¿Seguro que quieres salir de la partida? Los demás jugadores seguirán jugando.';

  @override
  String get finishGameDialogButton => '¡Sí, terminar!';

  @override
  String get leaveGameDialogButton => 'Salir de la partida.';

  @override
  String get continueGameDialogButton => 'No, seguir jugando.';

  @override
  String get dialogTextRoundFinishedBy => '¿Quién terminó la ronda?';

  @override
  String get dialogTitleLoadFinishedGame => 'Partida sin terminar';

  @override
  String get dialogTextLoadFinishedGame =>
      'No terminaste la última partida. ¿Quieres cargarla?';

  @override
  String get loadGameDialogButton => '¡Sí, cargar partida!';

  @override
  String get notLoadGameDialogButton => 'No, no cargar.';

  @override
  String get announcementDialogOkayButton => 'Vale';

  @override
  String get enterDialogButton => 'Guardar';

  @override
  String get enterPointsDialogTitle => 'Introducir puntos';

  @override
  String get dialogRoundFinishedTitle => '¡Ronda terminada!';

  @override
  String get dialogCancel => 'Cancelar';

  @override
  String get dialogEnterPoints => 'Introducir puntos';

  @override
  String dialogPointsRoundFinished(int round) {
    return 'Ronda $round terminada';
  }

  @override
  String get dialogKeypadNext => 'Siguiente';

  @override
  String get dialogKeypadDone => 'Listo';

  @override
  String get publishDialogTitle => 'Publicar partida';

  @override
  String get publishDialogReadyToPublish =>
      'Tu partida está lista para publicarse.';

  @override
  String get publishDialogLoading => 'Publicando tu partida...';

  @override
  String get publishDialogGamePublished => 'Tu partida ya es pública';

  @override
  String get publishDialogJoinedGame => 'Estás en una partida pública';

  @override
  String get publishDialogFriendsCanJoin =>
      'Otros pueden unirse a la partida con este código QR:';

  @override
  String get publishDialogPublish => 'Publicar partida';

  @override
  String get publishDialogNextSteps =>
      'Introduce los puntos después de cada ronda: tus compañeros los verán al instante.';

  @override
  String get publishDialogContinueToGame => 'Ir a la partida';

  @override
  String get publishDialogCodeStaysAvailable =>
      'Puedes volver a ver el código en cualquier momento en «Pública».';

  @override
  String get publishDialogFailedToPublish => 'No se pudo publicar la partida.';

  @override
  String get authScreenSignInHeadline => '¿Listo para tu próxima aventura?';

  @override
  String get authScreenSignInToPublish =>
      'Regístrate para publicar tu partida.';

  @override
  String get authScreenSignInPrivacyHint =>
      'Seguro y rápido. Nunca compartimos tus datos personales.';

  @override
  String get authScreenSignInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get authScreenSignInFailed =>
      'No se pudo iniciar sesión. Inténtalo de nuevo.';

  @override
  String get authScreenSignInWithEmail =>
      'Iniciar sesión/registrarse con e-mail';

  @override
  String get authScreenEmail => 'E-mail';

  @override
  String get authScreenPassword => 'Contraseña';

  @override
  String get authScreenPasswordRepeat => 'Confirmar contraseña';

  @override
  String get authScreenSignIn => 'Iniciar sesión';

  @override
  String get authScreenAlreadyAccount => '¿Ya tienes una cuenta? Inicia sesión';

  @override
  String get authScreenRegister => 'Registrarse';

  @override
  String get authScreenPasswortMissmatch => 'Las contraseñas no coinciden.';

  @override
  String get authScreenStartRegister => '¿Aún no tienes cuenta? Regístrate';

  @override
  String get authScreenBack => 'Atrás';

  @override
  String get authScreenShowPassword => 'Mostrar contraseña';

  @override
  String get authScreenHidePassword => 'Ocultar contraseña';

  @override
  String get authScreenForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get authScreenPasswordResetSent =>
      'Te hemos enviado un enlace para restablecer tu contraseña.';

  @override
  String get verifyEmailUseOtherAccount => 'Usar otra dirección';

  @override
  String get authScreenEmailAlreadyInUse =>
      'Ya existe una cuenta con este e-mail.';

  @override
  String get authScreenLinkConflictHint =>
      'Inicia sesión para usar esa cuenta. Las partidas online que empezaste en este dispositivo no se vincularán a ella.';

  @override
  String get authScreenInvalidCredentials =>
      'El e-mail o la contraseña no son correctos.';

  @override
  String get authScreenWeakPassword => 'Usa al menos 8 caracteres.';

  @override
  String get authScreenInvalidEmail =>
      'Introduce una dirección de e-mail válida.';

  @override
  String get authScreenTooManyRequests =>
      'Demasiados intentos. Espera un momento.';

  @override
  String get authScreenNetworkError => 'Sin conexión. Inténtalo de nuevo.';

  @override
  String get authScreenEmailRequired => 'Introduce tu dirección de e-mail.';

  @override
  String get authScreenPasswordRequired => 'Introduce una contraseña.';

  @override
  String get verifyEmailTitle => 'Confirma tu e-mail';

  @override
  String verifyEmailDescription(String email) {
    return 'Hemos enviado un enlace de confirmación a $email. Ábrelo y vuelve aquí.';
  }

  @override
  String get authScreenMailSpamHint =>
      '¿No te ha llegado? Revisa la carpeta de spam y márcalo como «no es spam»; así llegará el siguiente.';

  @override
  String get verifyEmailResend => 'Reenviar';

  @override
  String verifyEmailResendIn(int seconds) {
    return 'Reenviar en $seconds s';
  }

  @override
  String get verifyEmailResent => 'Correo enviado.';

  @override
  String get verifyEmailCheckNow => 'Ya lo he confirmado';

  @override
  String get verifyEmailStillPending =>
      'Aún no está confirmado. Abre el enlace del correo.';

  @override
  String get accountCardTitle => 'Cuenta';

  @override
  String get accountCardAnonymous => 'Juegas sin cuenta';

  @override
  String get accountCardAnonymousHint => 'Regístrate para publicar partidas.';

  @override
  String get accountCardVerified => 'E-mail confirmado';

  @override
  String get accountCardUnverified => 'E-mail aún sin confirmar';

  @override
  String get accountCardSignOut => 'Cerrar sesión';

  @override
  String get joinGameScreenScanToJoin =>
      'Escanea un código QR para unirte a una partida.';

  @override
  String get joinGameScreenGameFound => '¡Partida encontrada!';

  @override
  String get joinGameScreenGameRounds => 'Rondas';

  @override
  String get joinGameScreenGamePoints => 'Puntos';

  @override
  String get joinGameScreenLoadingStatus => 'Se ha detectado un ID de partida';

  @override
  String get joinGameScreenSearchingGame => 'Buscando la partida...';

  @override
  String get joinGameScreenGameNotFound => 'No se encontró la partida.';

  @override
  String get joinGameScreenGameAlreadyFinished =>
      'Esta partida ya ha terminado y no es posible unirse.';

  @override
  String get joinGameScreenScanQrCode => 'Escanear código QR';

  @override
  String get joinGameScreenEnterIdInstead => 'Introducir ID';

  @override
  String get joinGameScreenGameIdLabel => 'ID de partida (p. ej. cabo-123-xyz)';

  @override
  String get joinGameScreenSearchButton => 'Buscar';

  @override
  String get joinGameScreenEnterIdToJoin =>
      'Introduce el ID de la partida para unirte.';

  @override
  String get joinGameScreenOrDivider => 'o';

  @override
  String get joinGameScreenManualLabel => 'ID de partida';

  @override
  String get joinGameScreenSearchGameButton => 'Buscar partida';

  @override
  String get joinGameScreenJoinButton => 'Unirse a la partida';

  @override
  String get historyScreenHours => 'Horas';

  @override
  String get historyScreenDays => 'Días';

  @override
  String get historyScreenMinutes => 'Minutos';

  @override
  String get historyScreenGamesCardTitle => 'Partidas';

  @override
  String get historyScreenGameTimeCardTitle => 'Tiempo de juego';

  @override
  String get historyScreenPlayedRoundsCardTitle => 'Rondas jugadas';

  @override
  String get historyScreenTotalPointsTitle => 'Puntos acumulados';

  @override
  String get historyScreenTitle => 'Historial';

  @override
  String get historyScreenSubtitle => 'Tus aventuras en la mesa de la cocina';

  @override
  String get historyScreenStreaksActive => 'Rachas activas';

  @override
  String get historyScreenDaysShort => 'd';

  @override
  String get historyScreenHoursShort => 'h';

  @override
  String get ruleScreenTitle => 'Reglas';

  @override
  String get ruleScreenKamikazePointsLabel => 'Puntos Kamikaze';

  @override
  String get ruleScreenTotalGamePointsLabel => 'Puntuación total';

  @override
  String get ruleScreenZeroPointsLabel => 'Ganador de ronda: 0 puntos';

  @override
  String get ruleScreenPrecisionLandingLabel => 'Exactamente 100';

  @override
  String get ruleScreenSaveButton => 'Guardar';

  @override
  String get ruleScreenResetRulesButton => 'Restablecer reglas';

  @override
  String get ruleScreenTotalPointsHint =>
      '«Puntuación total»: define a partir de qué puntuación termina la partida. Si un jugador alcanza exactamente este valor, se aplica la regla «Exactamente 100». Si lo supera, la partida termina.';

  @override
  String get ruleScreenKamikazeHint =>
      'Regla «Kamikaze»: si un jugador termina una ronda con este valor, todos los demás reciben los puntos Kamikaze y el jugador Kamikaze recibe 0. Aquí puedes ajustar el valor a partir del cual se aplica «Kamikaze».';

  @override
  String get ruleScreenRoundWinnerHint =>
      'Regla «Puntuación»: el jugador que gana la ronda recibe 0 puntos. Si desactivas esta regla, el ganador de la ronda recibe los puntos con los que ganó.';

  @override
  String get ruleScreenExactly100Hint =>
      'Regla «Exactamente 100»: si un jugador alcanza exactamente la puntuación total, su puntuación se reduce a la mitad. Si la supera, la partida termina. Puedes ajustar el valor editando la puntuación total.';

  @override
  String get ruleScreenScoreSection => 'Límites de puntos';

  @override
  String get ruleScreenMechanicsSection => 'Mecánicas de juego';

  @override
  String get ruleScreenTotalPointsDescription =>
      'La partida termina en cuanto un jugador supera esta puntuación.';

  @override
  String get ruleScreenKamikazeDescription =>
      'Regla especial: quien termina una ronda con exactamente esta puntuación recibe 0 y todos los demás reciben esta puntuación. Con 0 se desactiva la regla.';

  @override
  String get ruleScreenZeroPointsDescription =>
      'Premia ganar una ronda: el ganador recibe 0 en lugar de los puntos de su mano.';

  @override
  String get ruleScreenPrecisionLandingDescription =>
      'Una oportunidad para remontar: quien alcanza exactamente la puntuación total ve sus puntos reducidos a la mitad.';

  @override
  String get roundBadgeKamikaze => 'KAMIKAZE';

  @override
  String get roundBadgeKamikazeTooltip =>
      'Ronda Kamikaze: el jugador Kamikaze recibe 0 y todos los demás reciben los puntos Kamikaze.';

  @override
  String get roundBadgePenaltyTooltip =>
      'Cabo fallido: 5 puntos de penalización además de los de la mano.';

  @override
  String get roundBadgePrecisionLandingTooltip =>
      'Acierto exacto: la puntuación se redujo a la mitad de la puntuación total.';

  @override
  String get ruleScreenPointsSuffix => 'pts';

  @override
  String get ruleScreenInfoCard =>
      'Estas reglas se aplican a todos los jugadores activos de esta ronda. Cambiarlas durante una partida puede provocar cálculos de puntos inesperados.';

  @override
  String get developerModeToggled => 'Modo desarrollador cambiado';

  @override
  String get aboutScreenTitle => 'Acerca de la app';

  @override
  String get aboutScreenSendButton => 'Enviar';

  @override
  String get aboutScreenTextAreaLabel => 'Tu mensaje';

  @override
  String get aboutScreenSuccess => '¡Gracias! Tu comentario se ha enviado.';

  @override
  String get aboutScreenTextAreaDescription =>
      '¿Te gusta la app? ¡Me encantaría recibir una valoración!';

  @override
  String get aboutScreenText =>
      'Creé esta app para que la experiencia del juego de cartas CABO sea aún mejor.';

  @override
  String get aboutScreenRatingButton => 'Valorar';

  @override
  String get aboutScreenFeedbackTitle => '¿Echas algo en falta?';

  @override
  String get aboutScreenFeedbackLabel => 'Tu mensaje';

  @override
  String get aboutScreenFeedbackHint => '¿Qué podríamos mejorar?';

  @override
  String get aboutScreenFeedbackButton => 'Enviar comentario';

  @override
  String get aboutScreenFeedbackAddImage => 'Adjuntar imagen';

  @override
  String get aboutScreenFeedbackChangeImage => 'Cambiar imagen';

  @override
  String get aboutScreenFeedbackSuccess => '¡Gracias por tu comentario!';

  @override
  String get aboutScreenFeedbackError => 'Error al enviar el comentario.';

  @override
  String get aboutScreenRatingHeadline => '¿Te gusta la app?';

  @override
  String get aboutScreenRatingDescription =>
      '¡Me haría muchísima ilusión una valoración en la tienda! Ayuda a que Cabo Board crezca.';

  @override
  String get aboutScreenFeedbackSubtitle => '¡Cuéntamelo!';

  @override
  String get aboutScreenEmailLabel => 'E-mail (opcional)';

  @override
  String get aboutScreenEmailHint => 'Tu dirección de e-mail';

  @override
  String get aboutScreenEmailInvalid =>
      'Introduce una dirección de e-mail válida.';

  @override
  String get aboutScreenFeedbackRequired => 'Escribe un mensaje.';

  @override
  String get aboutScreenFunFact =>
      '¿Sabías que el nombre viene del español? «Cabo» significa «final», como en «al fin y al cabo», justo lo que dices cuando quieres ganar.';

  @override
  String get rateAppTitle => 'Valora esta app';

  @override
  String get rateAppDescription =>
      '¿Cómo valorarías tu experiencia con Cabo Board?';

  @override
  String get feedbackLabel => 'Tu comentario (opcional)';

  @override
  String get submitRating => 'Enviar';

  @override
  String get maybeLater => 'Quizás más tarde';

  @override
  String get winnerDialogTitle => '¡Partida terminada!';

  @override
  String get hasWonText => 'ha ganado';

  @override
  String get withPointsText => 'con';

  @override
  String get pointsText => 'puntos';

  @override
  String get okButton => 'OK';

  @override
  String get endGameRankingTitle => 'Clasificación';

  @override
  String get endGameBackToMenu => 'Volver al menú';

  @override
  String get endGameDurationLabel => 'Duración';

  @override
  String get endGameDurationUnitMinutes => 'min';

  @override
  String get endGameDurationUnitHours => 'h';

  @override
  String get endGameRoundsLabel => 'Rondas';

  @override
  String get endGameRoundsUnit => 'Total';

  @override
  String get endGameDetailedTitle => 'Estadísticas detalladas';

  @override
  String get endGameStatTotal => 'Total';

  @override
  String get endGameStatCaboZero => 'Cabo-0';

  @override
  String get endGameStatPenalty => 'Penaliz.';

  @override
  String get endGameStatAverage => 'Media / R';

  @override
  String get endGamePointsShort => 'pts';

  @override
  String get endGameHighlightsTitle => 'Momentos destacados';

  @override
  String get endGameHighlightBestRound => 'Mejor ronda (menos puntos)';

  @override
  String get endGameHighlightTotalSuffix => 'en total';

  @override
  String get endGameRoundLabel => 'Ronda';

  @override
  String get endGameHighlightLongestStreak => 'Racha de victorias más larga';

  @override
  String endGameHighlightStreakRounds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rondas seguidas',
      one: '1 ronda seguida',
    );
    return '$_temp0';
  }

  @override
  String get endGameStreakWinTitle => 'Racha de victorias';

  @override
  String get endGameStreakDurationTitle => 'Partida larga';

  @override
  String get streakTitle => 'Rachas';

  @override
  String get streakFiveRoundsWon => 'Un jugador ganó 5 rondas seguidas.';

  @override
  String get streakSevenRoundsWon => 'Un jugador ganó 7 rondas seguidas.';

  @override
  String get streakTenRoundsWon => 'Un jugador ganó 10 rondas seguidas.';

  @override
  String get streakOneHourGame => 'Partida de más de 1 hora';

  @override
  String get streakOneAndHalfHourGame =>
      'Partida de más de 1 hora y 30 minutos';

  @override
  String get streakTwoHourGame => 'Partida de más de 2 horas';

  @override
  String get designSectionTitle => 'Diseño';

  @override
  String get designSectionSubtitle => 'Elige el aspecto de la app';

  @override
  String get designModern => 'Moderno';

  @override
  String get designClassic => 'Clásico';

  @override
  String get designModernDescription => 'El aspecto claro y moderno.';

  @override
  String get designClassicDescription =>
      'El aspecto original verde oscuro con imagen de fondo.';
}
