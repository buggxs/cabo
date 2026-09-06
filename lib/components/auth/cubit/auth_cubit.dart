import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/domain/application/auth_service.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthFormState> {
  AuthCubit({required this.applicationCubit}) : super(const AuthFormState());

  final ApplicationCubit applicationCubit;

  static const int resendCooldownSeconds = 60;
  static const int minPasswordLength = 8;

  Timer? _cooldownTimer;

  /// Emits only while the cubit is alive. The widget owning it is torn down
  /// as soon as the account becomes publishable, which can happen while an
  /// await is still in flight.
  void _safeEmit(AuthFormState next) {
    if (isClosed) return;
    emit(next);
  }

  void showChooser() => _safeEmit(const AuthFormState());

  void showSignIn() => _safeEmit(state.copyWith(mode: AuthMode.signIn));

  void showRegister() => _safeEmit(state.copyWith(mode: AuthMode.register));

  Future<bool> signInWithGoogle() async {
    _safeEmit(state.copyWith(isSubmitting: true));
    final AuthOutcome outcome = await applicationCubit.signInWithGoogle();
    // Cancelling the Google sheet is not a failure worth showing.
    final bool isCancelled = outcome.error == AuthError.cancelled;
    _safeEmit(
      state.copyWith(
        isSubmitting: false,
        error: outcome.isSuccess || isCancelled ? null : outcome.error,
      ),
    );
    return outcome.isSuccess;
  }

  Future<bool> signIn({required String email, required String password}) async {
    // No length rule here: accounts created before the minimum was raised
    // would otherwise be locked out of their own sign-in form.
    if (!_validate(email: email, password: password, isNewPassword: false)) {
      return false;
    }
    _safeEmit(state.copyWith(isSubmitting: true));
    final AuthOutcome outcome = await applicationCubit.signInWithEmail(
      email.trim(),
      password,
    );
    _emitOutcome(outcome);
    return outcome.isSuccess;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String passwordRepeat,
  }) async {
    if (!_validate(email: email, password: password, isNewPassword: true)) {
      return false;
    }
    if (password != passwordRepeat) {
      _safeEmit(state.copyWith(passwordFieldError: AuthError.passwordMismatch));
      return false;
    }
    _safeEmit(state.copyWith(isSubmitting: true));
    final AuthOutcome outcome = await applicationCubit.registerWithEmail(
      email.trim(),
      password,
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
      return false;
    }
    if (!outcome.isSuccess) {
      _emitOutcome(outcome);
      return false;
    }
    // The account exists now. A failing mail is reported on its own, so the
    // notice never claims a mail went out when it did not.
    final AuthOutcome mailOutcome = await applicationCubit
        .sendVerificationEmail();
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
    return true;
  }

  Future<bool> sendPasswordReset(String email) async {
    final String trimmedEmail = email.trim();
    if (!_isValidEmail(trimmedEmail)) {
      _safeEmit(state.copyWith(emailFieldError: AuthError.invalidEmail));
      return false;
    }
    _safeEmit(state.copyWith(isSubmitting: true));
    final AuthOutcome outcome = await applicationCubit.sendPasswordResetEmail(
      trimmedEmail,
    );
    _safeEmit(
      state.copyWith(
        isSubmitting: false,
        error: outcome.isSuccess ? null : outcome.error,
        hasPasswordResetBeenSent: outcome.isSuccess,
      ),
    );
    return outcome.isSuccess;
  }

  Future<void> resendVerificationEmail() async {
    if (!state.canResendVerification) {
      return;
    }
    _safeEmit(
      state.copyWith(isSubmitting: true, hasVerificationMailBeenSent: false),
    );
    final AuthOutcome outcome = await applicationCubit.sendVerificationEmail();
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

  /// Returns true once the address is confirmed. The state update itself comes
  /// from the ApplicationCubit's user stream.
  Future<bool> checkVerification() async {
    _safeEmit(
      state.copyWith(isSubmitting: true, hasVerificationMailBeenSent: false),
    );
    final bool isVerified = await applicationCubit.refreshVerificationStatus();
    _safeEmit(state.copyWith(isSubmitting: false));
    return isVerified;
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
