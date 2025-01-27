import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Terms of Use for Chatify',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Effective Date: December 15, 2023',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            buildSection(
              '1. Acceptance of Terms',
              'By using Chatify, you agree to comply with these Terms of Use. '
                  'If you do not agree with any part of these terms, please do not use our application.',
            ),
            buildSection(
              '2. User Accounts',
              '• You are responsible for maintaining the confidentiality of your account credentials and ensuring that your account information is accurate.\n'
                  '• You must be at least [age] years old to use Chatify.',
            ),
            buildSection(
              '3. User Conduct',
              '• You agree not to use Chatify for any unlawful or prohibited purpose.\n'
                  '• You agree not to engage in any activity that may interfere with or disrupt the proper functioning of Chatify.\n'
                  '• You agree not to impersonate others or use false information.',
            ),
            buildSection(
              '4. Content and Intellectual Property',
              'Details about intellectual property will go here (you can fill this content as needed).',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
