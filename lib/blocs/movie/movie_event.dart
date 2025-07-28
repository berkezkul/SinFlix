import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class LoadMovies extends MovieEvent {}

class LoadMoreMovies extends MovieEvent {}

class RefreshMovies extends MovieEvent {}

class ToggleFavorite extends MovieEvent {
  final String movieId;

  const ToggleFavorite(this.movieId);

  @override
  List<Object> get props => [movieId];
} 