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
      
      try {
        final token = await TokenStorage.getToken();
        if (token == null) return;
        
        print('🎬 Toggling favorite for movie: ${currentMovie.title}');
        final success = await movieRepository.toggleFavorite(event.movieId, token);
        
        if (success) {
          // Favorileme durumunu güncelle
          final updatedMovie = currentMovie.copyWith(isFavorite: !currentMovie.isFavorite);
          print('🎬 Favorite toggled successfully: ${updatedMovie.isFavorite}');
          emit(MovieDetailLoaded(updatedMovie));
        } else {
          print('❌ Failed to toggle favorite');
        }
      } catch (e) {
        print('❌ Toggle favorite error: $e');
        // Error state'e geçmek yerine mevcut state'i koru
      }
    }
  }
} 