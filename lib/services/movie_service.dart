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

  // Favorileme toggle (API: POST /movie/favorite/{favoriteId})
  Future<bool> toggleFavorite(String movieId, String token) async {
    print('🎬 Toggle favorite API call:');
    print('📍 URL: $baseUrl/movie/favorite/$movieId');
    print('🔑 Token: ${token.substring(0, 20)}...');
    
    final response = await http.post(
      Uri.parse('$baseUrl/movie/favorite/$movieId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    print('💖 Toggle favorite API response: ${response.statusCode} - ${response.body}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // API formatı: {"response": {"code": 200, "message": ""}, "data": {"movie": {...}}}
      // Movie objesi varsa başarılı
      bool isSuccess = data['data'] != null && data['data']['movie'] != null;
      
      print('✅ Toggle favorite success: $isSuccess');
      
      return isSuccess;
    } else {
      print('❌ Toggle favorite failed: Status ${response.statusCode}');
      return false;
    }
  }

  // Favori filmler listesi (API: GET /movie/favorites)
  Future<List<Movie>?> getFavoriteMovies(String token) async {
    print('🎬 Get favorites API call:');
    print('📍 URL: $baseUrl/movie/favorites');
    
    final response = await http.get(
      Uri.parse('$baseUrl/movie/favorites'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    print('💖 Favorite movies API response: ${response.statusCode} - ${response.body}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('📊 Favorite movies data structure: $data');
      
      // Gerçek API formatı: {"response": {...}, "data": [movie1, movie2, ...]}
      if (data['data'] != null && data['data'] is List) {
        final favoriteMovies = (data['data'] as List)
            .map((movie) => Movie.fromJson(movie))
            .toList();
        print('✅ Parsed ${favoriteMovies.length} favorite movies');
        
        // İlk film adını da yazdır
        if (favoriteMovies.isNotEmpty) {
          print('🎬 First favorite movie: ${favoriteMovies.first.title}');
        }
        
        return favoriteMovies;
      } else {
        print('⚠️ Data is not a list or null: ${data['data']?.runtimeType}');
        return [];
      }
    } else {
      print('❌ Get favorites failed: Status ${response.statusCode}');
      return null;
    }
  }
} 