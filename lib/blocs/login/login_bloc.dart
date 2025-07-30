import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email, error: null));
    });
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password, error: null));
    });
    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });
    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      // Simülasyon: Giriş işlemi
      await Future.delayed(const Duration(seconds: 1));
      if (state.email == "test@test.com" && state.password == "123456") {
        emit(state.copyWith(isLoading: false, error: null));
        // Başarılı girişte yönlendirme işlemini view'da
      } else {
        emit(state.copyWith(isLoading: false, error: "E-posta veya şifre hatalı"));
      }
    });
  }
}