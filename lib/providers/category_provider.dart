import 'package:flutter/foundation.dart';
import '../models/category.dart' as cat;

class CategoryProvider extends ChangeNotifier {
  List<cat.Category> _categories = [];
  bool _isLoading = false;

  List<cat.Category> get categories => _categories;
  bool get isLoading => _isLoading;

  CategoryProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Sample data
    _categories = [
      cat.Category(
        id: 1,
        name: 'Eletrônicos',
        description: 'Dispositivos eletrônicos em geral',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      cat.Category(
        id: 2,
        name: 'Computadores',
        description: 'Computadores, notebooks e acessórios',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      cat.Category(
        id: 3,
        name: 'Casa e Jardim',
        description: 'Produtos para casa e jardim',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
    ];
  }

  Future<void> addCategory(cat.Category category) async {
    _setLoading(true);
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final newCategory = category.copyWith(
      id: _getNextId(),
      createdAt: DateTime.now(),
    );
    
    _categories.add(newCategory);
    _setLoading(false);
  }

  Future<void> updateCategory(cat.Category updatedCategory) async {
    _setLoading(true);
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _categories.indexWhere((category) => category.id == updatedCategory.id);
    if (index != -1) {
      _categories[index] = updatedCategory;
    }
    
    _setLoading(false);
  }

  Future<void> deleteCategory(int id) async {
    _setLoading(true);
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    _categories.removeWhere((category) => category.id == id);
    _setLoading(false);
  }

  cat.Category? getCategoryById(int id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  String getCategoryName(int id) {
    final category = getCategoryById(id);
    return category?.name ?? 'Categoria não encontrada';
  }

  int _getNextId() {
    if (_categories.isEmpty) return 1;
    return _categories.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}