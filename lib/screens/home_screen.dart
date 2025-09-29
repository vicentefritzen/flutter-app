import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter CRUD App'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.account_circle),
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    enabled: false,
                    child: Text('Olá, ${authProvider.currentUser?['name'] ?? 'Usuário'}!'),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: const Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Sair'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'logout') {
                    await authProvider.logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.dashboard,
                      size: 48,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Bem-vindo ao Sistema CRUD',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Gerencie usuários, produtos e categorias de forma simples e eficiente.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Menu Options
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _MenuCard(
                    icon: Icons.people,
                    title: 'Usuários',
                    subtitle: 'Gerenciar usuários do sistema',
                    color: Colors.blue,
                    onTap: () => context.push('/users'),
                  ),
                  _MenuCard(
                    icon: Icons.inventory,
                    title: 'Produtos',
                    subtitle: 'Gerenciar produtos',
                    color: Colors.green,
                    onTap: () => context.push('/products'),
                  ),
                  _MenuCard(
                    icon: Icons.category,
                    title: 'Categorias',
                    subtitle: 'Gerenciar categorias',
                    color: Colors.orange,
                    onTap: () => context.push('/categories'),
                  ),
                  _MenuCard(
                    icon: Icons.info,
                    title: 'Sobre',
                    subtitle: 'Informações do app',
                    color: Colors.purple,
                    onTap: () => _showAboutDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre o App'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flutter CRUD App'),
            SizedBox(height: 8),
            Text('Versão: 1.0.0'),
            SizedBox(height: 8),
            Text('Desenvolvido com Flutter'),
            SizedBox(height: 8),
            Text('Features:'),
            Text('• Autenticação de usuários'),
            Text('• CRUD de Usuários'),
            Text('• CRUD de Produtos'),
            Text('• CRUD de Categorias'),
            Text('• Gerenciamento de estado com Provider'),
            Text('• Navegação com GoRouter'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}