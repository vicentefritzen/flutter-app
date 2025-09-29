import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../models/product.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/products/add'),
          ),
        ],
      ),
      body: Consumer2<ProductProvider, CategoryProvider>(
        builder: (context, productProvider, categoryProvider, child) {
          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productProvider.products.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum produto encontrado',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              final categoryName = categoryProvider.getCategoryName(product.categoryId);
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(product.name.substring(0, 1).toUpperCase()),
                  ),
                  title: Text(product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Categoria: $categoryName',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'R\$ ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () => context.push('/products/edit/${product.id}'),
                            child: const Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 8),
                                Text('Editar'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () => _showDeleteDialog(context, product),
                            child: const Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Excluir', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () => _showProductDetails(context, product, categoryName),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product, String categoryName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(label: 'Descrição', value: product.description),
            _DetailRow(label: 'Preço', value: 'R\$ ${product.price.toStringAsFixed(2)}'),
            _DetailRow(label: 'Categoria', value: categoryName),
            _DetailRow(
              label: 'Criado em',
              value: '${product.createdAt.day}/${product.createdAt.month}/${product.createdAt.year}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/products/edit/${product.id}');
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir o produto \"${product.name}\"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<ProductProvider>(context, listen: false)
                  .deleteProduct(product.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produto excluído com sucesso')),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}