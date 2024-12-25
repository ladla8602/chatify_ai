import 'package:get/get.dart';

class CommonController extends GetxController {
  var isDarkMode = false.obs;
  var enableForNewChats = false.obs;
  var chatHistory = true.obs;
  var dataTraining = true.obs;
  var dataEncryption = true.obs;

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
  }

  void toggleEnableForNewChats() {
    enableForNewChats.value = !enableForNewChats.value;
  }

  void toggleChatHistory() {
    chatHistory.value = !chatHistory.value;
  }

  void toggleDataTraining() {
    dataTraining.value = !dataTraining.value;
  }

  void toggleDataEncryption() {
    dataEncryption.value = !dataEncryption.value;
  }
}
