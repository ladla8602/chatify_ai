import 'package:chatify_ai/controllers/chat_controller.dart';
import 'package:chatify_ai/controllers/chatbot_controller.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(ChatbotController());
    Get.put(ChatController());
  }
}
