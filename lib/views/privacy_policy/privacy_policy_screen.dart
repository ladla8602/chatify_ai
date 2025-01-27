import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
              'Privacy Policy for Chatify',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Effective Date: December 20, 2023',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            buildSection(
              '1. Introduction',
              'Welcome to Chatify! This Privacy Policy outlines our practices concerning the collection, use, and protection of your personal information when you use our application. '
                  'By using Chatify, you agree to the terms and practices described in this Privacy Policy.',
            ),
            buildSection(
              '2. Information We Collect',
              '',
            ),
            buildSubSection(
              '2.1. Personal Information',
              'We may collect personal information, such as your name, email address, and payment details, when you create an account, make purchases, or contact our support team.',
            ),
            buildSubSection(
              '2.2. Usage Data',
              'We collect information about how you interact with Chatify, including your chat history, messages, and interactions with our chatbot.',
            ),
            buildSubSection(
              '2.3. Device Information',
              'We may collect information about the devices you use to access Chatify, including device type, operating system, and unique device identifiers.',
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
          if (content.isNotEmpty) const SizedBox(height: 8),
          if (content.isNotEmpty)
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildSubSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
