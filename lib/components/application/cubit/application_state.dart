part of 'application_cubit.dart';

sealed class ApplicationState extends Equatable {
  const ApplicationState();

  @override
  List<Object> get props => [];
}

final class ApplicationInitial extends ApplicationState {}
