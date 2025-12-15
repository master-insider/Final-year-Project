// lib/core/navigation/app_route_guard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../config/app_routes.dart'; // Used for redirecting to Login route

/// A widget that acts as a gatekeeper, checking authentication status before
/// displaying the actual content (the child widget).
class AppRouteGuard extends StatelessWidget {
  final Widget child;

  const AppRouteGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Listen to the AuthProvider for changes in status
    final auth = context.watch<AuthProvider>();

    // 1. Still loading user data (e.g., reading token from storage)
    if (auth.isLoading) { 
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading application state...'),
            ],
          ),
        ),
      );
    }

    // 2. Not Logged In -> Redirect to Login screen
    if (!auth.isAuthenticated) {
      return const LoginScreen();
    }
    
    // 3. Logged In -> Show the requested screen
    return child;
  }
}