import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../repositories/user_repository.dart';
import '../../utils/helpers/token_storage.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc(this.userRepository) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final token = await TokenStorage.getToken();
        if (token == null || token.isEmpty) {
          emit(const ProfileError("Oturum bulunamadı, lütfen tekrar giriş yapın."));
          return;
        }

        final user = await userRepository.getProfile(token);
        if (user != null) {
          emit(ProfileLoaded(user));
        } else {
          emit(const ProfileError("Kullanıcı bilgileri alınamadı."));
        }
      } catch (e) {
        emit(ProfileError("Hata oluştu: $e"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        await TokenStorage.deleteToken();
        emit(ProfileInitial());
      } catch (e) {
        emit(ProfileError("Çıkış yaparken hata oluştu: $e"));
      }
    });
  }
} 