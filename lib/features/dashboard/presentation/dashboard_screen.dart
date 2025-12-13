import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/presentation/providers/auth_provider.dart';
import '../../dashboard/domain/dashboard_repository.dart';
import 'widgets/dashboard_cards.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool loading = false;
  Map<String, dynamic>? stats;
  List<dynamic>? recentExpenses;

  final repo = DashboardRepository();

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    setState(() => loading = true);

    stats = await repo.getStats();
    recentExpenses = await repo.getRecentExpenses();

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${user?.name ?? ''}"),
        automaticallyImplyLeading: false,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadDashboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // SUMMARY CARDS -------------------------
                    DashboardCard(
                      icon: Icons.wallet,
                      title: "Total Spent (This Month)",
                      value: "Ksh ${stats?['total_spent'] ?? 0}",
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),

                    DashboardCard(
                      icon: Icons.savings,
                      title: "Remaining Budget",
                      value: "Ksh ${stats?['remaining_budget'] ?? 0}",
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),

                    DashboardCard(
                      icon: Icons.category,
                      title: "Top Category",
                      value: "${stats?['top_category'] ?? 'N/A'}",
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),

                    const Divider(),
                    const SizedBox(height: 16),

                    // RECENT EXPENSES ----------------------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Recent Expenses",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (recentExpenses == null || recentExpenses!.isEmpty)
                      const Text("No recent expenses"),
                    if (recentExpenses != null)
                      ...recentExpenses!.map((e) {
                        return ListTile(
                          leading: const Icon(Icons.receipt),
                          title: Text(e['name']),
                          subtitle: Text("Ksh ${e['amount']}"),
                          trailing: Text(e['date']),
                        );
                      }),
                  ],
                ),
              ),
            ),
    );
  }
}
