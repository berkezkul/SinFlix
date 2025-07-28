import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class ToggleMovieFavorite extends MovieDetailEvent {
  final String movieId;

  const ToggleMovieFavorite(this.movieId);

  @override
  List<Object> get props => [movieId];
} 