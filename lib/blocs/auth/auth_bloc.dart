import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repositories/user_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc(this.userRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final token = await userRepository.login(event.email, event.password);
      if (token != null) {
        emit(AuthSuccess(token));
      } else {
        emit(AuthFailure("Giriş başarısız!"));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      final token = await userRepository.register(event.name, event.email, event.password);
      print('Register token: $token');
      // Token JWT formatında mı kontrol et
      if (token != null && token.contains('.') && token.length > 20) {
        print('Register token is valid JWT, using it');
        emit(AuthSuccess(token));
      } else if (token != null) {
        print('Register token is not valid, trying auto login');
        // Token yoksa veya geçersizse, otomatik login dene
        final loginToken = await userRepository.login(event.email, event.password);
        print('Auto login token: $loginToken');
        if (loginToken != null && loginToken.contains('.') && loginToken.length > 20) {
          print('Auto login token is valid JWT, using it');
          emit(AuthSuccess(loginToken));
        } else {
          print('Auto login also failed');
          emit(AuthFailure("Kayıt başarılı, lütfen giriş yapın."));
        }
      } else {
        print('Register failed, no token returned');
        emit(AuthFailure("Kayıt başarısız!"));
      }
    });
  }
}