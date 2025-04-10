import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'settings/profile_settings_screen.dart';
import 'settings/privacy_settings_screen.dart';
import 'settings/help_support_screen.dart';
import 'settings/about_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedCurrency = '₹ (INR)';

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                setState(() => _selectedLanguage = 'English');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Hindi'),
              onTap: () {
                setState(() => _selectedLanguage = 'Hindi');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('₹ (INR)'),
              onTap: () {
                setState(() => _selectedCurrency = '₹ (INR)');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('\$ (USD)'),
              onTap: () {
                setState(() => _selectedCurrency = '\$ (USD)');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => ListView(
          children: [
            _buildSection(
              'Account',
              [
                _buildSettingTile(
                  icon: Icons.person_outline,
                  title: 'Profile Settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileSettingsScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingTile(
                  icon: Icons.security_outlined,
                  title: 'Privacy & Security',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacySettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            _buildSection(
              'Preferences',
              [
                _buildSettingTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                ),
                _buildSettingTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                  ),
                ),
                _buildSettingTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: _selectedLanguage,
                  onTap: () {
                    _showLanguageDialog();
                  },
                ),
                _buildSettingTile(
                  icon: Icons.attach_money,
                  title: 'Currency',
                  subtitle: _selectedCurrency,
                  onTap: () {
                    _showCurrencyDialog();
                  },
                ),
              ],
            ),
            _buildSection(
              'Support',
              [
                _buildSettingTile(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpSupportScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingTile(
                  icon: Icons.info_outline,
                  title: 'About EcoDrop',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            _buildSection(
              'Legal',
              [
                _buildSettingTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Terms of Service coming soon')),
                    );
                  },
                ),
                _buildSettingTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Privacy Policy coming soon')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
