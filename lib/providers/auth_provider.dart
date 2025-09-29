import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  bool _isLoading = false;
  Map<String, String>? _currentUser;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  Map<String, String>? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _isLoggedIn = await _authService.isLoggedIn();
    if (_isLoggedIn) {
      _currentUser = await _authService.getCurrentUser();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final success = await _authService.login(email, password);
      if (success) {
        _isLoggedIn = true;
        _currentUser = await _authService.getCurrentUser();
      } else {
        _errorMessage = 'Email ou senha inválidos';
      }
      return success;
    } catch (e) {
      _errorMessage = 'Erro ao fazer login: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final success = await _authService.register(name, email, password);
      if (success) {
        _isLoggedIn = true;
        _currentUser = await _authService.getCurrentUser();
      } else {
        _errorMessage = 'Email já está em uso';
      }
      return success;
    } catch (e) {
      _errorMessage = 'Erro ao criar conta: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}