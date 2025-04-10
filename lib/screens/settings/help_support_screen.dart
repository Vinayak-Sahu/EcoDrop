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
            subtitle: const Text('support@ecodrop.com'),
            onTap: () {
              // TODO: Implement email support
            },
          ),
          const Divider(),

          // Phone Support
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone Support'),
            subtitle: const Text('+1 (555) 123-4567'),
            onTap: () {
              // TODO: Implement phone support
            },
          ),
          const Divider(),

          // Live Chat
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Live Chat'),
            subtitle: const Text('Chat with our support team'),
            onTap: () {
              // TODO: Implement live chat
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
          const Divider(),

          // Resources Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Resources',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // User Guide
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('User Guide'),
            subtitle: const Text('Learn how to use EcoDrop'),
            onTap: () {
              // TODO: Implement user guide
            },
          ),
          const Divider(),

          // Recycling Guidelines
          ListTile(
            leading: const Icon(Icons.recycling),
            title: const Text('Recycling Guidelines'),
            subtitle: const Text('Learn about our recycling process'),
            onTap: () {
              // TODO: Implement recycling guidelines
            },
          ),
          const Divider(),

          // Community Guidelines
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Community Guidelines'),
            subtitle: const Text('Understand our community rules'),
            onTap: () {
              // TODO: Implement community guidelines
            },
          ),
          const Divider(),

          // Feedback Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Feedback',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Submit Feedback
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Submit Feedback'),
            subtitle: const Text('Help us improve our service'),
            onTap: () {
              // TODO: Implement feedback submission
            },
          ),
          const Divider(),

          // Report an Issue
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Report an Issue'),
            subtitle: const Text('Let us know if you encounter any problems'),
            onTap: () {
              // TODO: Implement issue reporting
            },
          ),
        ],
      ),
    );
  }
}
