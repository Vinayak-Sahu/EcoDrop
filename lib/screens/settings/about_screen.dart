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
                Image.asset(
                  'assets/images/ecodrop_logo.png',
                  height: 200,
                  width: 200,
                ),
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
            subtitle: const Text('2-B, Yamuna Marg, Civil Lines, Delhi-110054'),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle: const Text('+91 8700331039'),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: const Text('vinayaksahuvs1@gmail.com'),
          ),
        ],
      ),
    );
  }
}
