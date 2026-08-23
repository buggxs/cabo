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
    this.wasVerificationResent = false,
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
  final bool wasVerificationResent;

  bool get canResendVerification => resendCooldown == 0 && !isSubmitting;

  AuthFormState copyWith({
    AuthMode? mode,
    bool? isSubmitting,
    AuthError? error,
    AuthError? emailFieldError,
    AuthError? passwordFieldError,
    bool? hasEmailConflict,
    int? resendCooldown,
    bool? wasVerificationResent,
  }) {
    return AuthFormState(
      mode: mode ?? this.mode,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      emailFieldError: emailFieldError,
      passwordFieldError: passwordFieldError,
      hasEmailConflict: hasEmailConflict ?? this.hasEmailConflict,
      resendCooldown: resendCooldown ?? this.resendCooldown,
      wasVerificationResent:
          wasVerificationResent ?? this.wasVerificationResent,
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
    wasVerificationResent,
  ];
}
