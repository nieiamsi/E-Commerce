import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static const String _usersKey = 'registered_users';

  // Save a new user to local storage (Database)
  Future<bool> registerUser(
    String username,
    String password,
    String email,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing local users map
    String? usersJson = prefs.getString(_usersKey);
    Map<String, dynamic> users = usersJson != null ? jsonDecode(usersJson) : {};

    // Check if user already exists locally
    if (users.containsKey(username)) {
      return false; // User already exists
    }

    // Add new user
    users[username] = {'password': password, 'email': email};

    await prefs.setString(_usersKey, jsonEncode(users));
    return true;
  }

  // Validate user from local database
  Future<bool> validateLocalUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString(_usersKey);

    if (usersJson == null) return false;

    Map<String, dynamic> users = jsonDecode(usersJson);
    if (users.containsKey(username)) {
      return users[username]['password'] == password;
    }

    return false;
  }
}
