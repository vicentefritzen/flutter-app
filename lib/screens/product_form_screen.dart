import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../models/product.dart';

class ProductFormScreen extends StatefulWidget {
  final int? productId;

  const ProductFormScreen({super.key, this.productId});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  int? _selectedCategoryId;

  bool get isEditing => widget.productId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadProductData();
    }
  }

  void _loadProductData() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final product = productProvider.getProductById(widget.productId!);
    if (product != null) {
      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toString();
      _selectedCategoryId = product.categoryId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Produto' : 'Novo Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do produto',
                    prefixIcon: Icon(Icons.inventory),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira o nome do produto';
                    }
                    if (value.trim().length < 2) {
                      return 'Nome deve ter pelo menos 2 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira a descrição do produto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Preço',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                    hintText: '0.00',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira o preço do produto';
                    }
                    final price = double.tryParse(value.trim());
                    if (price == null || price <= 0) {
                      return 'Por favor, insira um preço válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedCategoryId,
                      items: categoryProvider.categories.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione uma categoria';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Consumer<ProductProvider>(
                    builder: (context, productProvider, child) {
                      return ElevatedButton(
                        onPressed: productProvider.isLoading ? null : _saveProduct,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                        child: productProvider.isLoading
                            ? const CircularProgressIndicator()
                            : Text(isEditing ? 'Atualizar' : 'Salvar'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    try {
      final price = double.parse(_priceController.text.trim());
      
      if (isEditing) {
        final existingProduct = productProvider.getProductById(widget.productId!);
        if (existingProduct != null) {
          final updatedProduct = existingProduct.copyWith(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            price: price,
            categoryId: _selectedCategoryId!,
          );
          await productProvider.updateProduct(updatedProduct);
        }
      } else {
        final newProduct = Product(
          id: 0, // Will be set by provider
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: price,
          categoryId: _selectedCategoryId!,
          createdAt: DateTime.now(), // Will be set by provider
        );
        await productProvider.addProduct(newProduct);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing 
                ? 'Produto atualizado com sucesso' 
                : 'Produto criado com sucesso',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar produto: $e')),
        );
      }
    }
  }
}