import '../services/user_service.dart';
import '../models/user.dart';

class UserRepository {
  final UserService _service = UserService();

  Future<String?> login(String email, String password) => _service.login(email, password);

  Future<User?> getProfile(String token) => _service.getProfile(token);

  Future<String?> register(String name, String email, String password) =>
      _service.register(name, email, password);

  Future<bool> uploadPhoto(String token, String photoUrl) =>
      _service.uploadPhoto(token, photoUrl);
}