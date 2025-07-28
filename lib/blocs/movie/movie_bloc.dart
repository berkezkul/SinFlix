import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_event.dart';
import 'movie_state.dart';
import '../../repositories/movie_repository.dart';
import '../../utils/helpers/token_storage.dart';
import '../../models/movie.dart'; // Added import for Movie model

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
        final movies = moviesData['movies'] as List<Movie>; // Movie listesi olarak cast
        print('🎬 Initial load - movies count: ${movies.length}');
        
        emit(state.copyWith(
          isLoading: false,
          movies: movies,
          currentPage: 1,
          hasReachedMax: false, // İlk yüklemede asla max'a ulaşmış olmayız!
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
    print('🎬 LoadMoreMovies called!');
    print('🔚 HasReachedMax: ${state.hasReachedMax}');
    print('⏳ IsLoadingMore: ${state.isLoadingMore}');
    
    if (state.hasReachedMax || state.isLoadingMore) {
      print('❌ LoadMoreMovies blocked - HasReachedMax: ${state.hasReachedMax}, IsLoadingMore: ${state.isLoadingMore}');
      return;
    }
    
    print('✅ LoadMoreMovies proceeding...');
    emit(state.copyWith(isLoadingMore: true));
    
    try {
      final token = await TokenStorage.getToken();
      final nextPage = state.currentPage + 1;
      print('📄 Loading page: $nextPage');
      
      final moviesData = await movieRepository.getMovies(page: nextPage, token: token);
      
      if (moviesData != null) {
        final newMovies = moviesData['movies'] as List<Movie>; // Movie listesi olarak cast
        print('🎬 New movies count: ${newMovies.length}');
        
        if (newMovies.isEmpty) {
          // Boş sayfa geldi, maksimuma ulaştık
          print('🔚 No more movies - setting hasReachedMax to true');
          emit(state.copyWith(
            isLoadingMore: false,
            hasReachedMax: true,
          ));
        } else {
          // Yeni filmler var, listeye ekle
          final allMovies = List<Movie>.from(state.movies)..addAll(newMovies);
          print('🎬 Total movies after adding: ${allMovies.length}');
          
          emit(state.copyWith(
            isLoadingMore: false,
            movies: allMovies,
            currentPage: nextPage,
            hasReachedMax: false,
          ));
        }
      } else {
        print('❌ moviesData is null');
        emit(state.copyWith(
          isLoadingMore: false,
          error: "Daha fazla film yüklenemedi",
        ));
      }
    } catch (e) {
      print('❌ LoadMoreMovies error: $e');
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
        final movies = moviesData['movies'] as List<Movie>; // Movie listesi olarak cast
        print('🔄 Refresh - movies count: ${movies.length}');
        
        emit(state.copyWith(
          isRefreshing: false,
          movies: movies,
          currentPage: 1,
          hasReachedMax: false, // Refresh sonrası da max'a ulaşmış olmayız!
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