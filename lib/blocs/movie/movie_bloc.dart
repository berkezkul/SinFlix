import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_event.dart';
import 'movie_state.dart';
import '../../repositories/movie_repository.dart';
import '../../utils/helpers/token_storage.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;

  MovieBloc(this.movieRepository) : super(const MovieState()) {
    on<LoadMovies>(_onLoadMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
    on<RefreshMovies>(_onRefreshMovies);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadMovies(LoadMovies event, Emitter<MovieState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final token = await TokenStorage.getToken();
      final moviesData = await movieRepository.getMovies(page: 1, token: token);
      
      if (moviesData != null) {
        emit(state.copyWith(
          isLoading: false,
          movies: moviesData['movies'],
          currentPage: moviesData['currentPage'],
          totalPages: moviesData['totalPages'],
          hasReachedMax: moviesData['currentPage'] >= moviesData['totalPages'],
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: "Filmler yüklenemedi",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "Hata oluştu: $e",
      ));
    }
  }

  Future<void> _onLoadMoreMovies(LoadMoreMovies event, Emitter<MovieState> emit) async {
    if (state.hasReachedMax || state.isLoadingMore) return;
    
    emit(state.copyWith(isLoadingMore: true));
    
    try {
      final token = await TokenStorage.getToken();
      final nextPage = state.currentPage + 1;
      final moviesData = await movieRepository.getMovies(page: nextPage, token: token);
      
      if (moviesData != null) {
        final newMovies = List.of(state.movies)..addAll(moviesData['movies']);
        
        emit(state.copyWith(
          isLoadingMore: false,
          movies: newMovies,
          currentPage: moviesData['currentPage'],
          totalPages: moviesData['totalPages'],
          hasReachedMax: moviesData['currentPage'] >= moviesData['totalPages'],
        ));
      } else {
        emit(state.copyWith(
          isLoadingMore: false,
          error: "Daha fazla film yüklenemedi",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        error: "Hata oluştu: $e",
      ));
    }
  }

  Future<void> _onRefreshMovies(RefreshMovies event, Emitter<MovieState> emit) async {
    emit(state.copyWith(isRefreshing: true, error: null));
    
    try {
      final token = await TokenStorage.getToken();
      final moviesData = await movieRepository.getMovies(page: 1, token: token);
      
      if (moviesData != null) {
        emit(state.copyWith(
          isRefreshing: false,
          movies: moviesData['movies'],
          currentPage: moviesData['currentPage'],
          totalPages: moviesData['totalPages'],
          hasReachedMax: moviesData['currentPage'] >= moviesData['totalPages'],
        ));
      } else {
        emit(state.copyWith(
          isRefreshing: false,
          error: "Filmler yenilenemedi",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isRefreshing: false,
        error: "Hata oluştu: $e",
      ));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<MovieState> emit) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) return;
      
      final success = await movieRepository.toggleFavorite(event.movieId, token);
      
      if (success) {
        // Film listesinde favorileme durumunu güncelle
        final updatedMovies = state.movies.map((movie) {
          if (movie.id == event.movieId) {
            return movie.copyWith(isFavorite: !movie.isFavorite);
          }
          return movie;
        }).toList();
        
        emit(state.copyWith(movies: updatedMovies));
      }
    } catch (e) {
      emit(state.copyWith(error: "Favorileme başarısız: $e"));
    }
  }
} 