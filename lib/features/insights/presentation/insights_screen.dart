import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/providers/insights_provider.dart';
// Assuming your chart widgets are located here:
// import '../presentation/widgets/pie_chart.dart'; 
// import '../presentation/widgets/line_chart.dart'; 

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  // Define a default time period (e.g., current year)
  final int _currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    // Load analytical data when the screen is accessed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InsightsProvider>(context, listen: false);
      
      // FIX 1: Replace loadAllInsights() with specific loading methods
      // For simplicity, we load the summary for the current month/period (null dates)
      // and the trend for the current year.
      provider.loadSpendingSummary(); 
      provider.loadMonthlySpendingTrend(_currentYear);
    });
  }

  // Helper to combine loading state checks
  bool _isAnyLoading(InsightsProvider provider) {
    return provider.isLoadingSummary || provider.isLoadingTrend;
  }
  
  // Helper to get the first available error message
  String? _getErrorMessage(InsightsProvider provider) {
    return provider.summaryErrorMessage ?? provider.trendErrorMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Insights'),
        actions: [
          // Example: Date range selector to call provider.loadSpendingSummary()
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () {
              // --- Logic to show date picker and reload summary ---
              // Example: provider.loadSpendingSummary(startDate: newStart, endDate: newEnd);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final provider = Provider.of<InsightsProvider>(context, listen: false);
              provider.loadSpendingSummary();
              provider.loadMonthlySpendingTrend(_currentYear);
            },
          ),
        ],
      ),
      body: Consumer<InsightsProvider>(
        builder: (context, provider, child) {
          // FIX 2: Check combined loading state
          if (_isAnyLoading(provider)) {
            // FIX 3: Check for specific loading state to provide better feedback
            if (provider.isLoadingSummary && provider.isLoadingTrend) {
              return const Center(child: Text('Loading all insights...'));
            }
            return const Center(child: CircularProgressIndicator());
          }
          
          final errorMessage = _getErrorMessage(provider);
          // FIX 4: Check for error message using helper
          if (errorMessage != null) {
            return Center(child: Text('Error loading insights: $errorMessage'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Spending Summary by Category',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                // --- Placeholder for Pie Chart ---
                // Data check for summary data before displaying the chart
                if (provider.spendingSummary.isEmpty)
                  const Center(child: Text('No spending data for the period.'))
                else
                  // 
                  Container(
                    height: 250,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Text('Pie Chart Widget Placeholder (using spendingSummary)'),
                  ),
                
                const SizedBox(height: 30),
                Text(
                  'Monthly Spending Trend (Year $_currentYear)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                // --- Placeholder for Line Chart ---
                // Data check for trend data before displaying the chart
                if (provider.monthlyTrend.isEmpty)
                  const Center(child: Text('No trend data for the year.'))
                else
                  // 
                  Container(
                    height: 250,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Text('Line Chart Widget Placeholder (using monthlyTrend)'),
                  ),

                const SizedBox(height: 30),
                Text('Budget Overrun Alerts:', style: Theme.of(context).textTheme.titleMedium),
                // Display categories where spent > limit
                ...provider.spendingSummary
                    .where((s) => s.totalSpent > s.budgetLimit)
                    .map((s) => ListTile(
                          leading: const Icon(Icons.warning, color: Colors.red),
                          title: Text('${s.category} Overspent!'),
                          subtitle: Text(
                              'Budget: \$${s.budgetLimit.toStringAsFixed(0)}, Spent: \$${s.totalSpent.toStringAsFixed(0)}'),
                        )),
              ],
            ),
          );
        },
      ),
    );
  }
}