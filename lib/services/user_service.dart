import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  static const String baseUrl = 'https://caseapi.servicelabs.tech';

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    print('Login response: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] != null && data['data']['token'] is String) {
        return data['data']['token'];
      }
      return null;
    }
    return null;
  }

  Future<User?> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    }
    return null;
  }

  Future<String?> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    print('Register response: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['data'] != null && data['data']['token'] is String) {
        return data['data']['token'];
      }
      return null;
    }
    return null;
  }

  Future<bool> uploadPhoto(String token, String photoUrl) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/upload_photo'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'photoUrl': photoUrl}),
    );
    return response.statusCode == 200;
  }
}