import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'database_service.dart';
import 'storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  final StorageService _storageService = StorageService();
  final DatabaseService _databaseService = DatabaseService();

  Future<bool> login(String username, String password) async {
    // 1. Check local database first (for newly signed-up users)
    bool isLocalUserValid = await _databaseService.validateLocalUser(
      username,
      password,
    );
    if (isLocalUserValid) {
      await _storageService.saveToken('local_token_$username');
      return true;
    }

    // 2. If not local, check Fake Store API
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        LoginRequest(username: username, password: password).toJson(),
      ),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final String token = body['token'];
      await _storageService.saveToken(token);
      return true;
    } else {
      throw Exception('Invalid username or password');
    }
  }
}
