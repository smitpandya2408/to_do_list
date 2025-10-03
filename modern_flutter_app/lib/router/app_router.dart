import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_flutter_app/screens/dashboard_screen.dart';
import 'package:modern_flutter_app/screens/login_screen.dart';
import 'package:modern_flutter_app/screens/register_screen.dart';
import 'package:modern_flutter_app/screens/products_screen.dart';
import 'package:modern_flutter_app/screens/user_details_screen.dart';

class AppRouter {
  static final _rootKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/login',
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
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/user',
        builder: (context, state) => const UserDetailsScreen(),
      ),
    ],
  );
}
