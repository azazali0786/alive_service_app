import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static const routeName = "/about";

  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alive Service App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Alive Service App is designed to facilitate direct communication between users and workers. '
              'With our app, you can easily find the nearest worker to you, view workers\' ratings, and call them directly. '
              'Here are some of the key features of our app:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Features:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const BulletPoint(text: 'Direct communication through calls.'),
            const BulletPoint(text: 'View call history.'),
            const BulletPoint(text: 'Find nearest workers based on your location.'),
            const BulletPoint(text: 'Sort workers based on ratings.'),
            const BulletPoint(text: 'Rate workers based on your experience.'),
            const SizedBox(height: 16),
            const Text(
              'We aim to provide a seamless experience for users to connect with workers quickly and efficiently. '
              'Your feedback is valuable to us, and we strive to improve our services continuously.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
