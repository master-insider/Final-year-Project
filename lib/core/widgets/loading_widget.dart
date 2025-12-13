import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final bool isLoading;
  final String? message;

  const LoadingWidget({super.key, required this.isLoading, this.message});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withOpacity(0.35),
      child: const Center(
        child: SizedBox(
          width: 120,
          height: 120,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }
}
