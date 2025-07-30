import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repositories/user_repository.dart';
import '../../services/navigation_service.dart';
import '../../utils/extensions/navigation_extensions.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;

  AuthBloc(this.userRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final token = await userRepository.login(event.email, event.password);
      if (token != null) {
        emit(AuthSuccess(token));
        // Context gerektirmeden navigation
        NavigationService.instance.showSuccess("Giriş başarılı!");
        NavigationService.instance.completeLogin();
      } else {
        emit(AuthFailure("Giriş başarısız!"));
        NavigationService.instance.showError("E-posta veya şifre hatalı!");
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      
      try {
        print('🔄 AuthBloc: Starting registration process...');
        
        final token = await userRepository.register(event.name, event.email, event.password);
        print('🔄 AuthBloc: Register token received: ${token?.substring(0, 20)}...');
        
        // Token JWT format check
        if (token != null && token.contains('.') && token.length > 20) {
          print('✅ AuthBloc: Register token is valid JWT, using it');
          emit(AuthSuccess(token));
          NavigationService.instance.showSuccess("Kayıt başarılı!");
          NavigationService.instance.completeRegistration();
        } else if (token != null) {
          print(' AuthBloc: Register token is not valid, trying auto login');
          final loginToken = await userRepository.login(event.email, event.password);
          print('🔄 AuthBloc: Auto login token: ${loginToken?.substring(0, 20)}...');
          
          if (loginToken != null && loginToken.contains('.') && loginToken.length > 20) {
            print(' AuthBloc: Auto login token is valid JWT, using it');
            emit(AuthSuccess(loginToken));
            NavigationService.instance.showSuccess("Kayıt başarılı!");
            NavigationService.instance.completeRegistration();
          } else {
            print(' AuthBloc: Auto login also failed');
            emit(AuthFailure("Kayıt başarılı, lütfen giriş yapın."));
            NavigationService.instance.showError("Kayıt başarılı, lütfen giriş yapın.");
          }
        } else {
          print(' AuthBloc: Register failed, no token returned');
          emit(AuthFailure("Kayıt başarısız! Lütfen internet bağlantınızı kontrol edin."));
          NavigationService.instance.showError("Kayıt başarısız! Lütfen internet bağlantınızı kontrol edin.");
        }
      } catch (e) {
        print(' AuthBloc: Register error: $e');
        emit(AuthFailure("Bağlantı hatası! Lütfen tekrar deneyin."));
        NavigationService.instance.showError("Bağlantı hatası! Lütfen tekrar deneyin.");
      }
    });
  }
}