import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _profileVisibility = true;
  bool _activityVisibility = true;
  bool _locationSharing = true;
  bool _dataCollection = true;
  bool _analyticsEnabled = true;
  bool _adPersonalization = false;
  bool _thirdPartySharing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
      ),
      body: ListView(
        children: [
          // Profile Visibility
          SwitchListTile(
            title: const Text('Profile Visibility'),
            subtitle:
                const Text('Allow others to see your profile information'),
            value: _profileVisibility,
            onChanged: (bool value) {
              setState(() {
                _profileVisibility = value;
              });
            },
          ),
          const Divider(),

          // Activity Visibility
          SwitchListTile(
            title: const Text('Activity Visibility'),
            subtitle: const Text('Show your recycling activities to others'),
            value: _activityVisibility,
            onChanged: (bool value) {
              setState(() {
                _activityVisibility = value;
              });
            },
          ),
          const Divider(),

          // Location Sharing
          SwitchListTile(
            title: const Text('Location Sharing'),
            subtitle: const Text('Share your location for pickup services'),
            value: _locationSharing,
            onChanged: (bool value) {
              setState(() {
                _locationSharing = value;
              });
            },
          ),
          const Divider(),

          // Data Collection
          SwitchListTile(
            title: const Text('Data Collection'),
            subtitle: const Text(
                'Allow collection of usage data to improve services'),
            value: _dataCollection,
            onChanged: (bool value) {
              setState(() {
                _dataCollection = value;
              });
            },
          ),
          const Divider(),

          // Analytics
          SwitchListTile(
            title: const Text('Analytics'),
            subtitle:
                const Text('Help us improve by sharing anonymous usage data'),
            value: _analyticsEnabled,
            onChanged: (bool value) {
              setState(() {
                _analyticsEnabled = value;
              });
            },
          ),
          const Divider(),

          // Ad Personalization
          SwitchListTile(
            title: const Text('Ad Personalization'),
            subtitle: const Text('Receive personalized advertisements'),
            value: _adPersonalization,
            onChanged: (bool value) {
              setState(() {
                _adPersonalization = value;
              });
            },
          ),
          const Divider(),

          // Third-Party Sharing
          SwitchListTile(
            title: const Text('Third-Party Sharing'),
            subtitle: const Text('Allow sharing of data with trusted partners'),
            value: _thirdPartySharing,
            onChanged: (bool value) {
              setState(() {
                _thirdPartySharing = value;
              });
            },
          ),
          const Divider(),

          // Data Management Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Data Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Export Data
          ListTile(
            title: const Text('Export Data'),
            subtitle: const Text('Download your personal data'),
            trailing: const Icon(Icons.download),
            onTap: () {
              // TODO: Implement data export
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data export started'),
                ),
              );
            },
          ),
          const Divider(),

          // Delete Account
          ListTile(
            title: const Text('Delete Account'),
            subtitle: const Text('Permanently delete your account and data'),
            trailing: const Icon(Icons.delete_forever),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Account'),
                  content: const Text(
                    'Are you sure you want to delete your account? This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement account deletion
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Account deletion initiated'),
                          ),
                        );
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
