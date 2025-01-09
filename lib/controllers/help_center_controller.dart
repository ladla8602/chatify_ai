import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class HelpCenterController extends GetxController {
  RxInt selectedTabIndex = 0.obs;
  RxInt selectedCategoryIndex = 0.obs;

  final RxList<String> categories =
      ['General', 'Account', 'Chatbot', 'Subscription'].obs;
  final List<Map<String, dynamic>> faqItems = [
    {
      'question': 'What is Chatify?',
      'answer':
          'Chatify is an AI-powered chatbot application designed to provide information, assistance, and engaging conversations.',
      'isExpanded': true,
    },
    {
      'question': 'How do I get started with Chatify?',
      'answer':
          'To get started, download the app and follow the onboarding process.',
      'isExpanded': false,
    },
    {
      'question': 'Is Chatify available for free?',
      'answer':
          'Yes, Chatify offers free and premium plans for different user needs.',
      'isExpanded': false,
    },
    {
      'question': 'Is my data safe with Chatify?',
      'answer':
          'Yes, Chatify prioritizes your data security with advanced encryption.',
      'isExpanded': false,
    },
    {
      'question': 'Can I delete my chat history?',
      'answer': 'Yes, you can delete your chat history from the settings menu.',
      'isExpanded': false,
    },
  ];
  final List<Map<String, dynamic>> contactUs = [
    {
      'icon': HugeIcons.strokeRoundedCall,
      'title': 'Customer Support',
    },
    {
      'icon': HugeIcons.strokeRoundedGlobal,
      'title': 'Website',
    },
    {
      'icon': HugeIcons.strokeRoundedWhatsapp,
      'title': 'WhatsApp',
    },
    {
      'icon': HugeIcons.strokeRoundedFacebook01,
      'title': 'Facebook',
    },
    {
      'icon': HugeIcons.strokeRoundedTwitter,
      'title': 'Twitter',
    },
    {
      'icon': HugeIcons.strokeRoundedInstagram,
      'title': 'Intagram',
    },
  ];

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  void updateCategories(List<String> newCategories) {
    categories.value = newCategories;
  }

  void fetchCategories() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate loading time
    List<String> fetchedCategories = [
      'General',
      'Account',
      'Chatbot',
      'Subscription'
    ];
    updateCategories(fetchedCategories); // Update categories after fetching
  }
}
