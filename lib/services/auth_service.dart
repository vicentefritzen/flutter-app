import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userEmailKey = 'userEmail';
  static const String _userNameKey = 'userName';

  // Simulated users database
  static final Map<String, Map<String, String>> _users = {
    'admin@example.com': {
      'password': '123456',
      'name': 'Administrador',
    },
    'user@example.com': {
      'password': '123456',
      'name': 'Usuário Teste',
    },
  };

  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (_users.containsKey(email) && _users[email]!['password'] == password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userEmailKey, email);
      await prefs.setString(_userNameKey, _users[email]!['name']!);
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (!_users.containsKey(email)) {
      _users[email] = {
        'password': password,
        'name': name,
      };
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userEmailKey, email);
      await prefs.setString(_userNameKey, name);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<Map<String, String>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    
    if (!isLoggedIn) return null;
    
    return {
      'email': prefs.getString(_userEmailKey) ?? '',
      'name': prefs.getString(_userNameKey) ?? '',
    };
  }
}