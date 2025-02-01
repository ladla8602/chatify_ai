import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class HelpCenterController extends GetxController {
  var selectedTabIndex = 0.obs;
  var selectedCategoryIndex = 0.obs;

  final RxList<String> categories =
      <String>[].obs; // ✅ Ensure it's an observable list

  final List<Map<String, dynamic>> faqItems = [
    {
      'question': 'What is Chatify?',
      'answer': 'Chatify is an AI-powered chatbot application.',
      'isExpanded': true,
    },
    {
      'question': 'How do I get started with Chatify?',
      'answer': 'Download the app and follow the onboarding process.',
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
  ];

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  void updateCategories(List<String> newCategories) {
    categories.assignAll(newCategories); // ✅ Correct way to update RxList
  }

  void fetchCategories() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate loading
    updateCategories(['General', 'Account', 'Chatbot', 'Subscription']);
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories(); // ✅ Load categories automatically
  }
}
