import 'package:equatable/equatable.dart';
import '../../models/movie.dart';

class MovieState extends Equatable {
  final List<Movie> movies;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? error;
  final int currentPage;
  final bool hasReachedMax;

  const MovieState({
    this.movies = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.error,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  MovieState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? error,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return MovieState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        movies,
        isLoading,
        isLoadingMore,
        isRefreshing,
        error,
        currentPage,
        hasReachedMax,
      ];
} 