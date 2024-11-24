part of 'about_cubit.dart';

@immutable
class AboutState extends Equatable {
  const AboutState({this.message = ''});

  final String message;

  AboutState copyWith({String? message}) {
    return AboutState(
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        message,
      ];
}
