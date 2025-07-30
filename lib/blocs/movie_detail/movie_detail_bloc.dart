import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';
import '../../repositories/movie_repository.dart';
import '../../utils/helpers/token_storage.dart';
import '../../models/movie.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final MovieRepository movieRepository;
  final Movie initialMovie;

  MovieDetailBloc(this.movieRepository, this.initialMovie) : super(MovieDetailLoaded(initialMovie)) {
    on<ToggleMovieFavorite>(_onToggleMovieFavorite);
  }

  Future<void> _onToggleMovieFavorite(ToggleMovieFavorite event, Emitter<MovieDetailState> emit) async {
    if (state is MovieDetailLoaded) {
      final currentState = state as MovieDetailLoaded;
      final currentMovie = currentState.movie;
      

      final optimisticMovie = currentMovie.copyWith(isFavorite: !currentMovie.isFavorite);
      emit(MovieDetailLoaded(optimisticMovie));
      print(' Movie detail optimistic update: "${currentMovie.title}" isFavorite: ${currentMovie.isFavorite} -> ${optimisticMovie.isFavorite}');
      
      try {
        final token = await TokenStorage.getToken();
        if (token == null) {
          // Token yoksa geri al
          emit(MovieDetailLoaded(currentMovie));
          return;
        }
        
        if (kDebugMode) {
          print(' Toggling favorite for movie: ${currentMovie.title}');
        }
        final success = await movieRepository.toggleFavorite(event.movieId, token);
        
        if (success) {
          if (kDebugMode) {
            print('🎬 Favorite toggled successfully: ${optimisticMovie.isFavorite}');
          }
          // Başarılı - optimistic update zaten yapıldı
        } else {
          if (kDebugMode) {
            print(' Failed to toggle favorite - reverting');
          }
          // Başarısızsa geri al
          emit(MovieDetailLoaded(currentMovie));
        }
      } catch (e) {
        if (kDebugMode) {
          print(' Toggle favorite error: $e');
        }
        // Hata durumunda geri al
        emit(MovieDetailLoaded(currentMovie));
      }
    }
  }
} 