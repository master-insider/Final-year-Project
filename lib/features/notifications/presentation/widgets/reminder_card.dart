import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ReminderCard({super.key, required this.title, required this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.alarm),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
