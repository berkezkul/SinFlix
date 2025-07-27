import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordAgain;
  final bool isPasswordVisible;
  final bool isPasswordAgainVisible;
  final bool agreementChecked;
  final bool isLoading;
  final String? error;

  const RegisterState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.passwordAgain = '',
    this.isPasswordVisible = false,
    this.isPasswordAgainVisible = false,
    this.agreementChecked = false,
    this.isLoading = false,
    this.error,
  });

  RegisterState copyWith({
    String? name,
    String? email,
    String? password,
    String? passwordAgain,
    bool? isPasswordVisible,
    bool? isPasswordAgainVisible,
    bool? agreementChecked,
    bool? isLoading,
    String? error,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordAgain: passwordAgain ?? this.passwordAgain,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isPasswordAgainVisible: isPasswordAgainVisible ?? this.isPasswordAgainVisible,
      agreementChecked: agreementChecked ?? this.agreementChecked,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    passwordAgain,
    isPasswordVisible,
    isPasswordAgainVisible,
    agreementChecked,
    isLoading,
    error,
  ];
}
