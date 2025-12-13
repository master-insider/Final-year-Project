import 'package:flutter/material.dart';
import '../../domain/insights_repository.dart';

class InsightsProvider extends ChangeNotifier {
  final InsightsRepository repository;
  
  InsightsProvider({required this.repository});
  
  Future<void> loadInsights() async {
    // Implementation
  }
}