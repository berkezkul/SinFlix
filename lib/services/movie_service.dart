import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const String baseUrl = 'https://caseapi.servicelabs.tech';

  // Film listesi çekme (sayfalama ile)
  Future<Map<String, dynamic>?> getMovies({int page = 1, String? token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/list?page=$page'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    
    print('Movie list API response: ${response.statusCode} - ${response.body}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Movie list data: $data');
      
      // Backend nested response formatı: {"response": {...}, "data": {"movies": [...]}}
      if (data['data'] != null && data['data']['movies'] != null) {
        final movies = (data['data']['movies'] as List)
            .map((movie) => Movie.fromJson(movie))
            .toList();
            
        return {
          'movies': movies,
          'currentPage': page,
          'hasMorePages': movies.isNotEmpty, // Film varsa daha fazla sayfa olabilir
        };
      }
    }
    return null;
  }

  // Film favorileme/unfavorite
  Future<bool> toggleFavorite(String movieId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/movie/favorite/$movieId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    print('Toggle favorite API response: ${response.statusCode} - ${response.body}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    }
    return false;
  }

  // Favori filmler listesi
  Future<List<Movie>?> getFavoriteMovies(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/favorites'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    print('Favorite movies API response: ${response.statusCode} - ${response.body}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Favorite movies data: $data');
      
      // Backend response formatına göre parse et
      if (data['movies'] != null) {
        return (data['movies'] as List)
            .map((movie) => Movie.fromJson(movie))
            .toList();
      }
    }
    return null;
  }
} 