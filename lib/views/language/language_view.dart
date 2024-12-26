import 'package:chatify_ai/constants/constants.dart';
import 'package:flutter/material.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  // List of languages
  final List<Map<String, String>> languages = [
    {'name': 'English (US)', 'flag': '🇺🇸'},
    {'name': 'English (UK)', 'flag': '🇬🇧'},
    {'name': 'Mandarin', 'flag': '🇨🇳'},
    {'name': 'Spanish', 'flag': '🇪🇸'},
    {'name': 'Hindi', 'flag': '🇮🇳'},
    {'name': 'French', 'flag': '🇫🇷'},
    {'name': 'Arabic', 'flag': '🇦🇪'},
    {'name': 'Russian', 'flag': '🇷🇺'},
    {'name': 'Japanese', 'flag': '🇯🇵'},
  ];

  String selectedLanguage = 'English (US)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Language',
          style: TextStyle(fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        separatorBuilder: (context, index) {
          return SizedBox(height: 14);
        },
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: selectedLanguage == language['name']
                      ? ColorConstant.primaryColor
                      : Colors.grey.shade300,
                  width: 1),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Text(
                language['flag']!,
                style: TextStyle(fontSize: 24),
              ),
              title: Text(
                language['name']!,
                style: TextStyle(fontSize: 14),
              ),
              trailing: selectedLanguage == language['name']
                  ? Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                setState(() {
                  selectedLanguage = language['name']!;
                });
              },
            ),
          );
        },
      ),
    );
  }
}
