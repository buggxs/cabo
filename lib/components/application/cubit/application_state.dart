part of 'application_cubit.dart';

abstract class ApplicationState extends Equatable {
  const ApplicationState({
    this.isDeveloper = false,
    this.design = AppDesign.modern,
  });

  final bool isDeveloper;
  final AppDesign design;

  User? get user => null;
  bool get isSignedIn => false;
  bool get isAnonymous => true;
  bool get isEmailVerified => false;
  String? get email => null;

  bool get hasAccount => isSignedIn && !isAnonymous;

  /// The server side equivalent of this lives in firestore.rules (games/create).
  bool get canPublishGame => hasAccount && isEmailVerified;

  bool get isAwaitingEmailVerification => hasAccount && !isEmailVerified;

  ApplicationState copyWith({bool? isDeveloper, AppDesign? design});

  @override
  List<Object?> get props => [isDeveloper, design];
}

class ApplicationInitial extends ApplicationState {
  const ApplicationInitial({super.isDeveloper, super.design});

  @override
  ApplicationInitial copyWith({bool? isDeveloper, AppDesign? design}) {
    return ApplicationInitial(
      isDeveloper: isDeveloper ?? this.isDeveloper,
      design: design ?? this.design,
    );
  }
}

class ApplicationUnauthenticated extends ApplicationState {
  const ApplicationUnauthenticated({super.isDeveloper, super.design});

  @override
  ApplicationUnauthenticated copyWith({bool? isDeveloper, AppDesign? design}) {
    return ApplicationUnauthenticated(
      isDeveloper: isDeveloper ?? this.isDeveloper,
      design: design ?? this.design,
    );
  }
}

class ApplicationAuthenticated extends ApplicationState {
  ApplicationAuthenticated({
    required this.user,
    bool? isDeveloper,
    AppDesign? design,
  }) : uid = user.uid,
       isAnonymous = user.isAnonymous,
       isEmailVerified = user.emailVerified,
       email = user.email,
       super(
         isDeveloper: isDeveloper ?? false,
         design: design ?? AppDesign.modern,
       );

  @override
  final User user;
  final String uid;
  @override
  final bool isAnonymous;
  @override
  final bool isEmailVerified;
  @override
  final String? email;

  @override
  bool get isSignedIn => true;

  @override
  ApplicationAuthenticated copyWith({
    User? user,
    bool? isDeveloper,
    AppDesign? design,
  }) {
    return ApplicationAuthenticated(
      user: user ?? this.user,
      isDeveloper: isDeveloper ?? this.isDeveloper,
      design: design ?? this.design,
    );
  }

  // uid instead of user: User is mutable and has no value equality, so an
  // emailVerified change after reload() would be swallowed by Equatable.
  @override
  List<Object?> get props => [
    uid,
    isAnonymous,
    isEmailVerified,
    email,
    isDeveloper,
    design,
  ];
}
