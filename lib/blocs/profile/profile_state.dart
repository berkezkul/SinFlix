import 'package:equatable/equatable.dart';
import '../../models/user.dart';
import '../../models/movie.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final List<Movie> favoriteMovies;
  final bool isLoadingFavorites;

  const ProfileLoaded(
    this.user, {
    this.favoriteMovies = const [],
    this.isLoadingFavorites = false,
  });

  ProfileLoaded copyWith({
    User? user,
    List<Movie>? favoriteMovies,
    bool? isLoadingFavorites,
  }) {
    return ProfileLoaded(
      user ?? this.user,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
      isLoadingFavorites: isLoadingFavorites ?? this.isLoadingFavorites,
    );
  }

  @override
  List<Object> get props => [user, favoriteMovies, isLoadingFavorites];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
} 