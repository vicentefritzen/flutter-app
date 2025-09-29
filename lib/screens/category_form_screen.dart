import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';

class CategoryFormScreen extends StatefulWidget {
  final int? categoryId;

  const CategoryFormScreen({super.key, this.categoryId});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool get isEditing => widget.categoryId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadCategoryData();
    }
  }

  void _loadCategoryData() {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final category = categoryProvider.getCategoryById(widget.categoryId!);
    if (category != null) {
      _nameController.text = category.name;
      _descriptionController.text = category.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Categoria' : 'Nova Categoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da categoria',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira o nome da categoria';
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
                    return 'Por favor, insira a descrição da categoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    return ElevatedButton(
                      onPressed: categoryProvider.isLoading ? null : _saveCategory,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: categoryProvider.isLoading
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
    );
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    try {
      if (isEditing) {
        final existingCategory = categoryProvider.getCategoryById(widget.categoryId!);
        if (existingCategory != null) {
          final updatedCategory = existingCategory.copyWith(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
          );
          await categoryProvider.updateCategory(updatedCategory);
        }
      } else {
        final newCategory = Category(
          id: 0, // Will be set by provider
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          createdAt: DateTime.now(), // Will be set by provider
        );
        await categoryProvider.addCategory(newCategory);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing 
                ? 'Categoria atualizada com sucesso' 
                : 'Categoria criada com sucesso',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar categoria: $e')),
        );
      }
    }
  }
}