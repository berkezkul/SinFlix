import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../repositories/user_repository.dart';
import '../../repositories/movie_repository.dart';
import '../../utils/helpers/token_storage.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  final MovieRepository movieRepository;

  ProfileBloc(this.userRepository, this.movieRepository) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<LoadFavoriteMovies>(_onLoadFavoriteMovies);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
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
        // Profil yüklendikten sonra favori filmleri de yükle
        add(LoadFavoriteMovies());
      } else {
        emit(const ProfileError("Kullanıcı bilgileri alınamadı."));
      }
    } catch (e) {
      emit(ProfileError("Hata oluştu: $e"));
    }
  }

  Future<void> _onLoadFavoriteMovies(LoadFavoriteMovies event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      
      emit(currentState.copyWith(isLoadingFavorites: true));
      
      try {
        final token = await TokenStorage.getToken();
        if (token == null) return;

        if (kDebugMode) {
          if (kDebugMode) {
            print(' Loading favorite movies for profile...');
          }
        }
        final favoriteMovies = await movieRepository.getFavoriteMovies(token);
        
        if (favoriteMovies != null) {
          if (kDebugMode) {
            print(' Loaded ${favoriteMovies.length} favorite movies');
          }
          emit(currentState.copyWith(
            favoriteMovies: favoriteMovies,
            isLoadingFavorites: false,
          ));
        } else {
          if (kDebugMode) {
            print(' Failed to load favorite movies');
          }
          emit(currentState.copyWith(
            favoriteMovies: [],
            isLoadingFavorites: false,
          ));
        }
      } catch (e) {
        if (kDebugMode) {
          print(' Error loading favorite movies: $e');
        }
        emit(currentState.copyWith(
          favoriteMovies: [],
          isLoadingFavorites: false,
        ));
      }
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<ProfileState> emit) async {
    try {
      await TokenStorage.deleteToken();
      emit(ProfileInitial());
    } catch (e) {
      emit(ProfileError("Çıkış yaparken hata oluştu: $e"));
    }
  }
} 