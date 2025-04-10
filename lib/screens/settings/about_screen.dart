import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '1.0.0';
  String _buildNumber = '1';

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  Future<void> _getPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: ListView(
        children: [
          // App Logo and Name
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(
                  Icons.recycling,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                const Text(
                  'EcoDrop',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Version $_version (Build $_buildNumber)',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // App Description
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'EcoDrop is your one-stop solution for responsible e-waste recycling. We make it easy to recycle your electronic devices while earning rewards for your environmental contribution.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const Divider(),

          // Company Information
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Company Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Company Name'),
            subtitle: const Text('EcoDrop Technologies'),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Address'),
            subtitle: const Text('123 Green Street, Eco City, EC 12345'),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle: const Text('+1 (555) 123-4567'),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: const Text('contact@ecodrop.com'),
          ),
          const Divider(),

          // Social Media Links
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Connect With Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.facebook),
            title: const Text('Facebook'),
            subtitle: const Text('@ecodrop'),
            onTap: () {
              // TODO: Implement Facebook link
            },
          ),
          const Divider(),

          ListTile(
            leading: Icon(Icons.alternate_email),
            title: const Text('Twitter'),
            subtitle: const Text('@ecodrop'),
            onTap: () {
              // TODO: Implement Twitter link
            },
          ),
          const Divider(),

          ListTile(
            leading: Icon(Icons.camera_alt),
            title: const Text('Instagram'),
            subtitle: const Text('@ecodrop'),
            onTap: () {
              // TODO: Implement Instagram link
            },
          ),
          const Divider(),

          // Legal Information
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Legal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Implement Terms of Service
            },
          ),
          const Divider(),

          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Implement Privacy Policy
            },
          ),
          const Divider(),

          ListTile(
            title: const Text('Cookie Policy'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Implement Cookie Policy
            },
          ),
          const Divider(),

          // Credits
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Credits',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '© 2024 EcoDrop Technologies. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
