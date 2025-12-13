// lib/features/dashboard/presentation/providers/dashboard_provider.dart

// Provider only depends on the abstract contract
class DashboardProvider extends ChangeNotifier {
  final AbstractDashboardRepository repository;

  DashboardProvider({required this.repository});
  // ...
}