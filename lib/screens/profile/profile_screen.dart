import 'package:flutter/material.dart';
import 'my_listings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget _buildProfileTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        children: [
          // ... existing profile header ...

          const Divider(),
          _buildProfileTile(
            'My Listings',
            'View and manage your listings',
            Icons.list_alt,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyListingsScreen(),
                ),
              );
            },
          ),
          // ... rest of the profile tiles ...
        ],
      ),
    );
  }
}
