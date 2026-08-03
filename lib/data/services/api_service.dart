import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  final StorageService _storageService = StorageService();

  Future<bool> login(String username, String password) async {
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

      // Save token locally
      await _storageService.saveToken(token);
      return true;
    } else {
      throw Exception('Invalid username or password');
    }
  }
}
