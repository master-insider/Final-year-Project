// lib/features/reports/presentation/reports_screen.dart
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Generate Financial Reports', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              // Placeholder for Date Range Picker
              ElevatedButton.icon(
                onPressed: () {
                  // Logic to trigger report generation API call
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generate Monthly PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}