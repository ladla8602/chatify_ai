import 'package:chatify_ai/controllers/chatbot_controller.dart';
import 'package:chatify_ai/controllers/image_gen_controller.dart';
import 'package:get/get.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatbotController());
    Get.put(ImageGenController());
  }
}
