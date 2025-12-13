import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Add your route generation logic here
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text('Route not implemented')),
      ),
    );
  }
}