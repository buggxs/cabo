part of 'application_cubit.dart';

abstract class ApplicationState extends Equatable {
  const ApplicationState({
    this.isDeveloper = false,
    this.design = AppDesign.modern,
  });

  final bool isDeveloper;
  final AppDesign design;

  ApplicationState copyWith({bool? isDeveloper, AppDesign? design});

  @override
  List<Object?> get props => [isDeveloper, design];
}

class ApplicationInitial extends ApplicationState {
  const ApplicationInitial({super.design}) : super(isDeveloper: false);

  @override
  ApplicationInitial copyWith({bool? isDeveloper, AppDesign? design}) {
    return ApplicationInitial(design: design ?? this.design);
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
  const ApplicationAuthenticated({
    required this.user,
    bool? isDeveloper,
    AppDesign? design,
  }) : super(
         isDeveloper: isDeveloper ?? false,
         design: design ?? AppDesign.modern,
       );

  final User user;

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

  @override
  List<Object?> get props => [user, super.isDeveloper, super.design];
}
