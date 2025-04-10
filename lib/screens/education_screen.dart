import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'home_screen.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn About E-Waste'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.recycling,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'E-Waste Management',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // What is E-Waste Section
            _buildSection(
              context,
              'What is E-Waste?',
              'Electronic waste, or e-waste, refers to discarded electronic devices and equipment. This includes everything from old phones and laptops to household appliances and industrial machinery.',
              Icons.devices,
            ),
            const SizedBox(height: 24),

            // Impact on Environment Section
            _buildSection(
              context,
              'Environmental Impact',
              'E-waste contains harmful materials like lead, mercury, and cadmium that can pollute our environment. When not properly disposed of, these toxins can seep into soil and water sources.',
              Icons.eco,
            ),
            const SizedBox(height: 24),

            // Why Recycle Section
            _buildSection(
              context,
              'Why Recycle E-Waste?',
              'Recycling e-waste helps recover valuable materials like gold, silver, and copper, reducing the need for mining new resources. It also prevents harmful substances from entering our environment.',
              Icons.recycling,
            ),
            const SizedBox(height: 24),

            // Common E-Waste Items
            Text(
              'Common E-Waste Items',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildEwasteItem(
              context,
              'Mobile Phones',
              'Contains valuable metals and harmful substances',
              Icons.phone_android,
            ),
            _buildEwasteItem(
              context,
              'Laptops & Computers',
              'Rich in precious metals and recyclable components',
              Icons.laptop,
            ),
            _buildEwasteItem(
              context,
              'Batteries',
              'Contains hazardous materials requiring special disposal',
              Icons.battery_alert,
            ),
            _buildEwasteItem(
              context,
              'Small Appliances',
              'Often contains recyclable metals and plastics',
              Icons.kitchen,
            ),
            const SizedBox(height: 24),

            // Recycling Process
            _buildSection(
              context,
              'The Recycling Process',
              '1. Collection: Devices are collected from users\n2. Sorting: Items are categorized by type\n3. Dismantling: Components are carefully separated\n4. Processing: Materials are extracted and purified\n5. Manufacturing: Recycled materials are used to make new products',
              Icons.science,
            ),
            const SizedBox(height: 24),

            // Tips for Proper Disposal
            _buildSection(
              context,
              'Tips for Proper Disposal',
              '• Remove batteries and memory cards\n• Wipe personal data\n• Use certified recycling centers\n• Keep devices in good condition\n• Consider donating working devices',
              Icons.tips_and_updates,
            ),
            const SizedBox(height: 24),

            // Quiz Section
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.quiz,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Test Your Knowledge',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Take a quick quiz to test your understanding of e-waste and recycling!',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuizScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Quiz'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Call to Action
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Ready to Recycle?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start making a difference today by properly disposing of your e-waste.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const HomeScreen();
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 500),
                          ),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.recycling),
                      label: const Text('Start Recycling'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEwasteItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }
}
