import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/product_provider.dart';
import 'providers/category_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/user_list_screen.dart';
import 'screens/user_form_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/product_form_screen.dart';
import 'screens/category_list_screen.dart';
import 'screens/category_form_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final router = GoRouter(
            initialLocation: '/login', // Sempre começar na tela de login
            redirect: (context, state) {
              final isLoggedIn = authProvider.isLoggedIn;
              final isLoginRoute = state.matchedLocation == '/login' || 
                                  state.matchedLocation == '/register';
              
              // Se não está logado e não está numa rota de login, redirecionar para login
              if (!isLoggedIn && !isLoginRoute) {
                return '/login';
              }
              
              // Se está logado e está numa rota de login, redirecionar para home
              if (isLoggedIn && isLoginRoute) {
                return '/home';
              }
              
              return null;
            },
            routes: [
              GoRoute(
                path: '/login',
                builder: (context, state) => const LoginScreen(),
              ),
              GoRoute(
                path: '/register',
                builder: (context, state) => const RegisterScreen(),
              ),
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                path: '/users',
                builder: (context, state) => const UserListScreen(),
              ),
              GoRoute(
                path: '/users/new',
                builder: (context, state) => const UserFormScreen(),
              ),
              GoRoute(
                path: '/users/edit/:userId',
                builder: (context, state) {
                  final userId = int.tryParse(state.pathParameters['userId'] ?? '');
                  return UserFormScreen(userId: userId);
                },
              ),
              GoRoute(
                path: '/products',
                builder: (context, state) => const ProductListScreen(),
              ),
              GoRoute(
                path: '/products/new',
                builder: (context, state) => const ProductFormScreen(),
              ),
              GoRoute(
                path: '/products/edit/:productId',
                builder: (context, state) {
                  final productId = int.tryParse(state.pathParameters['productId'] ?? '');
                  return ProductFormScreen(productId: productId);
                },
              ),
              GoRoute(
                path: '/categories',
                builder: (context, state) => const CategoryListScreen(),
              ),
              GoRoute(
                path: '/categories/new',
                builder: (context, state) => const CategoryFormScreen(),
              ),
              GoRoute(
                path: '/categories/edit/:categoryId',
                builder: (context, state) {
                  final categoryId = int.tryParse(state.pathParameters['categoryId'] ?? '');
                  return CategoryFormScreen(categoryId: categoryId);
                },
              ),
            ],
          );

          return MaterialApp.router(
            title: 'Flutter CRUD Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
