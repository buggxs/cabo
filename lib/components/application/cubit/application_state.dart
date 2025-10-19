part of 'application_cubit.dart';

abstract class ApplicationState extends Equatable {
  const ApplicationState({this.isDeveloper = false});

  final bool isDeveloper;

  ApplicationState copyWith({bool? isDeveloper});

  @override
  List<Object?> get props => [isDeveloper];
}

class ApplicationInitial extends ApplicationState {
  const ApplicationInitial() : super(isDeveloper: false);

  @override
  ApplicationInitial copyWith({bool? isDeveloper}) {
    return const ApplicationInitial();
  }
}

class ApplicationUnauthenticated extends ApplicationState {
  const ApplicationUnauthenticated({super.isDeveloper});

  @override
  ApplicationUnauthenticated copyWith({bool? isDeveloper}) {
    return ApplicationUnauthenticated(
      isDeveloper: isDeveloper ?? this.isDeveloper,
    );
  }
}

class ApplicationAuthenticated extends ApplicationState {
  const ApplicationAuthenticated({required this.user, bool? isDeveloper})
    : super(isDeveloper: isDeveloper ?? false);

  final User user;

  @override
  ApplicationAuthenticated copyWith({User? user, bool? isDeveloper}) {
    return ApplicationAuthenticated(
      user: user ?? this.user,
      isDeveloper: isDeveloper ?? this.isDeveloper,
    );
  }

  @override
  List<Object?> get props => [user, super.isDeveloper];
}
