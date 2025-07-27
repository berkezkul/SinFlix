import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NameChanged extends RegisterEvent {
  final String name;
  NameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class EmailChanged extends RegisterEvent {
  final String email;
  EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends RegisterEvent {
  final String password;
  PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class PasswordAgainChanged extends RegisterEvent {
  final String passwordAgain;
  PasswordAgainChanged(this.passwordAgain);

  @override
  List<Object?> get props => [passwordAgain];
}

class TogglePasswordVisibility extends RegisterEvent {}

class TogglePasswordAgainVisibility extends RegisterEvent {}

class AgreementToggled extends RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {}