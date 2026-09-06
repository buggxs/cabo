part of 'auth_cubit.dart';

enum AuthMode { chooser, signIn, register }

class AuthFormState extends Equatable {
  const AuthFormState({
    this.mode = AuthMode.chooser,
    this.isSubmitting = false,
    this.error,
    this.emailFieldError,
    this.passwordFieldError,
    this.hasEmailConflict = false,
    this.resendCooldown = 0,
    this.hasVerificationMailBeenSent = false,
    this.hasPasswordResetBeenSent = false,
  });

  final AuthMode mode;
  final bool isSubmitting;
  final AuthError? error;
  final AuthError? emailFieldError;
  final AuthError? passwordFieldError;

  /// Set when the e-mail already belongs to an account, so the UI can offer
  /// signing in instead of registering.
  final bool hasEmailConflict;
  final int resendCooldown;
  final bool hasVerificationMailBeenSent;
  final bool hasPasswordResetBeenSent;

  bool get canResendVerification => resendCooldown == 0 && !isSubmitting;

  AuthFormState copyWith({
    AuthMode? mode,
    bool? isSubmitting,
    AuthError? error,
    AuthError? emailFieldError,
    AuthError? passwordFieldError,
    bool? hasEmailConflict,
    int? resendCooldown,
    bool? hasVerificationMailBeenSent,
    bool? hasPasswordResetBeenSent,
  }) {
    return AuthFormState(
      mode: mode ?? this.mode,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      emailFieldError: emailFieldError,
      passwordFieldError: passwordFieldError,
      hasEmailConflict: hasEmailConflict ?? this.hasEmailConflict,
      resendCooldown: resendCooldown ?? this.resendCooldown,
      hasVerificationMailBeenSent:
          hasVerificationMailBeenSent ?? this.hasVerificationMailBeenSent,
      hasPasswordResetBeenSent:
          hasPasswordResetBeenSent ?? this.hasPasswordResetBeenSent,
    );
  }

  /// Only touches the cooldown. copyWith deliberately clears the error fields,
  /// which would make the one-second ticker wipe a validation message.
  AuthFormState withCooldown(int seconds) {
    return AuthFormState(
      mode: mode,
      isSubmitting: isSubmitting,
      error: error,
      emailFieldError: emailFieldError,
      passwordFieldError: passwordFieldError,
      hasEmailConflict: hasEmailConflict,
      resendCooldown: seconds,
      hasVerificationMailBeenSent: hasVerificationMailBeenSent,
      hasPasswordResetBeenSent: hasPasswordResetBeenSent,
    );
  }

  @override
  List<Object?> get props => [
    mode,
    isSubmitting,
    error,
    emailFieldError,
    passwordFieldError,
    hasEmailConflict,
    resendCooldown,
    hasVerificationMailBeenSent,
    hasPasswordResetBeenSent,
  ];
}
