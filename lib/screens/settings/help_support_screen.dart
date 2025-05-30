import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        children: [
          // Contact Support Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Email Support
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email Support'),
            subtitle: const Text('vinayaksahuvs1@gmail.com'),
            onTap: () {
              // TODO: Implement email support
            },
          ),
          const Divider(),

          // Phone Support
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone Support'),
            subtitle: const Text('+91 8700331039'),
            onTap: () {
              // TODO: Implement phone support
            },
          ),
          const Divider(),

          // FAQ Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // FAQ Items
          ExpansionTile(
            title: const Text('How do I schedule a pickup?'),
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'To schedule a pickup, go to the "Schedule Pickup" screen, select your items, choose a preferred date and time, and confirm your location. Our team will arrive at your doorstep to collect the items.',
                ),
              ),
            ],
          ),
          const Divider(),

          ExpansionTile(
            title: const Text('What items can I recycle?'),
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'We accept various electronic items including smartphones, laptops, tablets, desktop computers, printers, and other electronic accessories. Check our recycling guidelines for a complete list.',
                ),
              ),
            ],
          ),
          const Divider(),

          ExpansionTile(
            title: const Text('How do I track my recycling points?'),
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Your recycling points are automatically updated in your profile after each successful pickup. You can view your points history in the "My Points" section.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
