import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    context.read<ProfileProvider>().loadProfile(auth);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final user = provider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text("No profile data"))
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        child: Text(user.name[0].toUpperCase(),
                            style: const TextStyle(fontSize: 30)),
                      ),
                      const SizedBox(height: 20),
                      Text("Name: ${user.name}",
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text("Email: ${user.email}",
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EditProfileScreen(user: user)),
                          );
                        },
                        child: const Text("Edit Profile"),
                      ),

                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          context.read<AuthProvider>().logout();
                        },
                        child: const Text("Logout"),
                      ),
                    ],
                  ),
                ),
    );
  }
}
