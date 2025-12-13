import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notifications_provider.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationsProvider()..initNotificationService(enablePush: true),
      builder: (context, child) {
        final prov = context.watch<NotificationsProvider>();

        return Scaffold(
          appBar: AppBar(title: const Text('Notifications')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  value: prov.enabled,
                  onChanged: (v) => prov.toggleEnabled(v),
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Enable/disable all notifications'),
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('Daily Summary Time'),
                  subtitle: Text(prov.dailyTime),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: int.parse(prov.dailyTime.split(':')[0]),
                          minute: int.parse(prov.dailyTime.split(':')[1]),
                        ),
                      );
                      if (time != null) {
                        await prov.scheduleDailySummary(time.hour, time.minute);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Daily summary scheduled')),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final token = await prov.getFcmToken();
                    if (token != null) {
                      // show token so user can share it for testing or backend registration
                      await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('FCM Token'),
                          content: SingleChildScrollView(child: Text(token)),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                          ],
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('FCM token not available')),
                      );
                    }
                  },
                  child: const Text('Get FCM Token'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => prov.showTestNotification(),
                  child: const Text('Send test notification (local)'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
