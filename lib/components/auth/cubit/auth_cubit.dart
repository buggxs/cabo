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
  static const int minPasswordLength = 6;

  Timer? _cooldownTimer;

  void showChooser() => emit(const AuthFormState());

  void showSignIn() => emit(state.copyWith(mode: AuthMode.signIn));

  void showRegister() => emit(state.copyWith(mode: AuthMode.register));

  Future<bool> signInWithGoogle() async {
    emit(state.copyWith(isSubmitting: true));
    final bool isSuccess = await applicationCubit.signInWithGoogle();
    emit(
      state.copyWith(
        isSubmitting: false,
        error: isSuccess ? null : AuthError.unknown,
      ),
    );
    return isSuccess;
  }

  Future<bool> signIn({required String email, required String password}) async {
    if (!_validate(email: email, password: password)) {
      return false;
    }
    emit(state.copyWith(isSubmitting: true));
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
    if (!_validate(email: email, password: password)) {
      return false;
    }
    if (password != passwordRepeat) {
      emit(state.copyWith(passwordFieldError: AuthError.passwordMismatch));
      return false;
    }
    emit(state.copyWith(isSubmitting: true));
    final AuthOutcome outcome = await applicationCubit.registerWithEmail(
      email.trim(),
      password,
    );
    final bool hasConflict =
        outcome.error == AuthError.emailAlreadyInUse ||
        outcome.error == AuthError.credentialAlreadyInUse ||
        outcome.error == AuthError.providerAlreadyLinked;
    if (hasConflict) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: AuthError.emailAlreadyInUse,
          hasEmailConflict: true,
        ),
      );
      return false;
    }
    _emitOutcome(outcome);
    if (outcome.isSuccess) {
      _startCooldown();
    }
    return outcome.isSuccess;
  }

  Future<void> resendVerificationEmail() async {
    if (!state.canResendVerification) {
      return;
    }
    emit(state.copyWith(isSubmitting: true, wasVerificationResent: false));
    final AuthOutcome outcome = await applicationCubit.sendVerificationEmail();
    emit(
      state.copyWith(
        isSubmitting: false,
        error: outcome.isSuccess ? null : outcome.error,
        wasVerificationResent: outcome.isSuccess,
      ),
    );
    if (outcome.isSuccess) {
      _startCooldown();
    }
  }

  /// Returns true once the address is confirmed. The state update itself comes
  /// from the ApplicationCubit's user stream.
  Future<bool> checkVerification() async {
    emit(state.copyWith(isSubmitting: true, wasVerificationResent: false));
    final bool isVerified = await applicationCubit.refreshVerificationStatus();
    emit(state.copyWith(isSubmitting: false));
    return isVerified;
  }

  bool _validate({required String email, required String password}) {
    final String trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || !trimmedEmail.contains('@')) {
      emit(state.copyWith(emailFieldError: AuthError.invalidEmail));
      return false;
    }
    if (password.length < minPasswordLength) {
      emit(state.copyWith(passwordFieldError: AuthError.weakPassword));
      return false;
    }
    emit(state.copyWith());
    return true;
  }

  void _emitOutcome(AuthOutcome outcome) {
    emit(
      state.copyWith(
        isSubmitting: false,
        error: outcome.isSuccess ? null : outcome.error,
      ),
    );
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    emit(state.copyWith(resendCooldown: resendCooldownSeconds));
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final int remaining = state.resendCooldown - 1;
      if (remaining <= 0) {
        timer.cancel();
      }
      if (!isClosed) {
        emit(state.copyWith(resendCooldown: remaining < 0 ? 0 : remaining));
      }
    });
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    return super.close();
  }
}
