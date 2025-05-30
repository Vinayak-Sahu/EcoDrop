import 'package:flutter/material.dart';
import 'home_screen.dart';

class SuccessScreen extends StatelessWidget {
  final String message;
  final String? details;
  final VoidCallback? onContinue;

  const SuccessScreen({
    super.key,
    required this.message,
    this.details,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              if (details != null) ...[
                const SizedBox(height: 16),
                Text(
                  details!,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (onContinue != null) {
                    onContinue!();
                  } else {
                    // Navigate to home screen
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('Continue to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
