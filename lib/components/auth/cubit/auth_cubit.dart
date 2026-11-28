import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cabo/domain/application/auth_service.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthFormState> {
  AuthCubit({required AuthService authService})
    : _authService = authService,
      super(const AuthFormState());

  final AuthService _authService;

  static const int resendCooldownSeconds = 60;
  static const int minPasswordLength = 8;

  Timer? _cooldownTimer;

  // The widget owning this cubit is torn down as soon as the account becomes
  // publishable, which can happen while an await is still in flight.
  void _safeEmit(AuthFormState next) {
    if (isClosed) return;
    emit(next);
  }

  void showChooser() => _safeEmit(const AuthFormState());

  void showSignIn() => _safeEmit(state.copyWith(mode: AuthMode.signIn));

  void showRegister() => _safeEmit(state.copyWith(mode: AuthMode.register));

  Future<void> signInWithGoogle() async {
    _safeEmit(state.copyWith(isSubmitting: true));
    final AuthOutcome outcome = await _authService.signInWithGoogle();
    // Cancelling the Google sheet is not a failure worth showing.
    final bool isCancelled = outcome.error == AuthError.cancelled;
    _safeEmit(
      state.copyWith(
        isSubmitting: false,
        error: outcome.isSuccess || isCancelled ? null : outcome.error,
      ),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    // No length rule here: accounts created before the minimum was raised
    // would otherwise be locked out of their own sign-in form.
    if (!_validate(email: email, password: password, isNewPassword: false)) {
      return;
    }
    _safeEmit(state.copyWith(isSubmitting: true));
    final AuthOutcome outcome = await _authService.signInWithEmail(
      email: email.trim(),
      password: password,
    );
    _emitOutcome(outcome);
  }

  Future<void> register({
    required String email,
    required String password,
    required String passwordRepeat,
  }) async {
    if (!_validate(email: email, password: password, isNewPassword: true)) {
      return;
    }
    if (password != passwordRepeat) {
      _safeEmit(state.copyWith(passwordFieldError: AuthError.passwordMismatch));
      return;
    }
    _safeEmit(state.copyWith(isSubmitting: true));
    final AuthOutcome outcome = await _authService.registerWithEmail(
      email: email.trim(),
      password: password,
    );
    final bool hasConflict =
        outcome.error == AuthError.emailAlreadyInUse ||
        outcome.error == AuthError.credentialAlreadyInUse ||
        outcome.error == AuthError.providerAlreadyLinked;
    if (hasConflict) {
      _safeEmit(
        state.copyWith(
          isSubmitting: false,
          error: AuthError.emailAlreadyInUse,
          hasEmailConflict: true,
        ),
      );
      return;
    }
    if (!outcome.isSuccess) {
      _emitOutcome(outcome);
      return;
    }
    // The account exists now. A failing mail is reported on its own, so the
    // notice never claims a mail went out when it did not.
    final AuthOutcome mailOutcome = await _authService.sendVerificationEmail();
    _safeEmit(
      state.copyWith(
        isSubmitting: false,
        error: mailOutcome.isSuccess ? null : mailOutcome.error,
        hasVerificationMailBeenSent: mailOutcome.isSuccess,
      ),
    );
    if (mailOutcome.isSuccess) {
      _startCooldown();
    }
  }

  Future<void> sendPasswordReset(String email) async {
    final String trimmedEmail = email.trim();
    if (!_isValidEmail(trimmedEmail)) {
      _safeEmit(state.copyWith(emailFieldError: AuthError.invalidEmail));
      return;
    }
    _safeEmit(state.copyWith(isSubmitting: true));
    final AuthOutcome outcome = await _authService.sendPasswordResetEmail(
      trimmedEmail,
    );
    _safeEmit(
      state.copyWith(
        isSubmitting: false,
        error: outcome.isSuccess ? null : outcome.error,
        hasPasswordResetBeenSent: outcome.isSuccess,
      ),
    );
  }

  Future<void> resendVerificationEmail() async {
    if (!state.canResendVerification) {
      return;
    }
    _safeEmit(
      state.copyWith(isSubmitting: true, hasVerificationMailBeenSent: false),
    );
    final AuthOutcome outcome = await _authService.sendVerificationEmail();
    _safeEmit(
      state.copyWith(
        isSubmitting: false,
        error: outcome.isSuccess ? null : outcome.error,
        hasVerificationMailBeenSent: outcome.isSuccess,
      ),
    );
    if (outcome.isSuccess) {
      _startCooldown();
    }
  }

  // The switch away from the notice once confirmed comes from the
  // ApplicationCubit's user stream, not from this state.
  Future<void> checkVerification() async {
    _safeEmit(
      state.copyWith(isSubmitting: true, hasVerificationMailBeenSent: false),
    );
    final bool isVerified = await _authService.refreshVerificationStatus();
    _safeEmit(
      state.copyWith(isSubmitting: false, isVerificationPending: !isVerified),
    );
  }

  bool _validate({
    required String email,
    required String password,
    required bool isNewPassword,
  }) {
    final String trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      _safeEmit(state.copyWith(emailFieldError: AuthError.emailRequired));
      return false;
    }
    if (!_isValidEmail(trimmedEmail)) {
      _safeEmit(state.copyWith(emailFieldError: AuthError.invalidEmail));
      return false;
    }
    if (password.isEmpty) {
      _safeEmit(state.copyWith(passwordFieldError: AuthError.passwordRequired));
      return false;
    }
    if (isNewPassword && password.length < minPasswordLength) {
      _safeEmit(state.copyWith(passwordFieldError: AuthError.weakPassword));
      return false;
    }
    _safeEmit(state.copyWith());
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  void _emitOutcome(AuthOutcome outcome) {
    _safeEmit(
      state.copyWith(
        isSubmitting: false,
        error: outcome.isSuccess ? null : outcome.error,
      ),
    );
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    _safeEmit(state.copyWith(resendCooldown: resendCooldownSeconds));
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final int remaining = state.resendCooldown - 1;
      if (remaining <= 0) {
        timer.cancel();
      }
      _safeEmit(state.withCooldown(remaining < 0 ? 0 : remaining));
    });
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    return super.close();
  }
}
