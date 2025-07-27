import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState()) {
    on<NameChanged>((event, emit) {
      emit(state.copyWith(name: event.name, error: null));
    });
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email, error: null));
    });
    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password, error: null));
    });
    on<PasswordAgainChanged>((event, emit) {
      emit(state.copyWith(passwordAgain: event.passwordAgain, error: null));
    });
    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });
    on<TogglePasswordAgainVisibility>((event, emit) {
      emit(state.copyWith(isPasswordAgainVisible: !state.isPasswordAgainVisible));
    });
    on<AgreementToggled>((event, emit) {
      emit(state.copyWith(agreementChecked: !state.agreementChecked));
    });
    on<RegisterSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      // Basit validasyon örneği
      if (state.name.isEmpty ||
          state.email.isEmpty ||
          state.password.isEmpty ||
          state.passwordAgain.isEmpty) {
        emit(state.copyWith(isLoading: false, error: "Tüm alanları doldurun."));
        return;
      }
      if (state.password != state.passwordAgain) {
        emit(state.copyWith(isLoading: false, error: "Şifreler uyuşmuyor."));
        return;
      }
      if (!state.agreementChecked) {
        emit(state.copyWith(isLoading: false, error: "Sözleşmeyi kabul etmelisiniz."));
        return;
      }
      // Simülasyon: Kayıt işlemi
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(isLoading: false, error: null));
      // Başarılı kayıt sonrası yönlendirme işlemini view'da yapabilirsin
    });
  }
}