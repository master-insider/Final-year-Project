import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import 'app_navbar.dart';

class AppRouteGuard extends StatelessWidget {
  final Widget? child;

  const AppRouteGuard({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Still loading user from storage
    if (auth.isLoadingUser) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Not logged in → redirect to login
    if (!auth.isAuthenticated) {
      return auth.buildLoginRedirectScreen();
    }

    // Logged in → show main app (navbar)
    return const AppNavbar();
  }
}
