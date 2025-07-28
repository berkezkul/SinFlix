import '../services/movie_service.dart';
import '../models/movie.dart';

class MovieRepository {
  final MovieService _service = MovieService();

  Future<Map<String, dynamic>?> getMovies({int page = 1, String? token}) => 
      _service.getMovies(page: page, token: token);

  Future<bool> toggleFavorite(String movieId, String token) => 
      _service.toggleFavorite(movieId, token);

  Future<List<Movie>?> getFavoriteMovies(String token) => 
      _service.getFavoriteMovies(token);
} 