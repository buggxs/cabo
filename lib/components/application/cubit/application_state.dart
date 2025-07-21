part of 'application_cubit.dart';

abstract class ApplicationState extends Equatable {
  const ApplicationState();

  @override
  List<Object?> get props => [];
}

class ApplicationInitial extends ApplicationState {}

class ApplicationUnauthenticated extends ApplicationState {}

class ApplicationAuthenticated extends ApplicationState {
  const ApplicationAuthenticated(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}
