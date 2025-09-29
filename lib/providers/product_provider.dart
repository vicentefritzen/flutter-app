import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  ProductProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Sample data
    _products = [
      Product(
        id: 1,
        name: 'Smartphone Samsung',
        description: 'Smartphone Android com 128GB',
        price: 1299.99,
        categoryId: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Product(
        id: 2,
        name: 'Notebook Dell',
        description: 'Notebook Dell Inspiron 15 com Intel i5',
        price: 2899.99,
        categoryId: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      Product(
        id: 3,
        name: 'Fone Bluetooth',
        description: 'Fone de ouvido sem fio com cancelamento de ruído',
        price: 299.99,
        categoryId: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  Future<void> addProduct(Product product) async {
    _setLoading(true);
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final newProduct = product.copyWith(
      id: _getNextId(),
      createdAt: DateTime.now(),
    );
    
    _products.add(newProduct);
    _setLoading(false);
  }

  Future<void> updateProduct(Product updatedProduct) async {
    _setLoading(true);
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _products.indexWhere((product) => product.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
    }
    
    _setLoading(false);
  }

  Future<void> deleteProduct(int id) async {
    _setLoading(true);
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    _products.removeWhere((product) => product.id == id);
    _setLoading(false);
  }

  Product? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> getProductsByCategory(int categoryId) {
    return _products.where((product) => product.categoryId == categoryId).toList();
  }

  int _getNextId() {
    if (_products.isEmpty) return 1;
    return _products.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}