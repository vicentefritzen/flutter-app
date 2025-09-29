import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  UserProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Sample data
    _users = [
      User(
        id: 1,
        name: 'João Silva',
        email: 'joao@example.com',
        phone: '(11) 99999-9999',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      User(
        id: 2,
        name: 'Maria Santos',
        email: 'maria@example.com',
        phone: '(11) 88888-8888',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      User(
        id: 3,
        name: 'Pedro Oliveira',
        email: 'pedro@example.com',
        phone: '(11) 77777-7777',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  Future<void> addUser(User user) async {
    _setLoading(true);
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final newUser = user.copyWith(
      id: _getNextId(),
      createdAt: DateTime.now(),
    );
    
    _users.add(newUser);
    _setLoading(false);
  }

  Future<void> updateUser(User updatedUser) async {
    _setLoading(true);
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
    }
    
    _setLoading(false);
  }

  Future<void> deleteUser(int id) async {
    _setLoading(true);
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    _users.removeWhere((user) => user.id == id);
    _setLoading(false);
  }

  User? getUserById(int id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  int _getNextId() {
    if (_users.isEmpty) return 1;
    return _users.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}