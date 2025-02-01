// lib/controllers/voice_chat_controller.dart

import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';

import '../services/firebase_functions_service.dart';
import '../services/speech_service.dart';

class VoiceChatController extends GetxController {
  final SpeechService _speechService = SpeechService();
  final FirebaseFunctionsService _functionsService = FirebaseFunctionsService();

  final isInitialized = false.obs;
  final isListening = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await _speechService.initialize();
    isInitialized.value = true;
  }

  Future<void> startVoiceChat() async {
    if (!isInitialized.value) return;

    try {
      final token = await _functionsService.getVoiceChatToken();
      await _speechService.startVoiceChat(token);
      isListening.value = true;
    } catch (e) {
      print('Error starting voice chat: $e');
      Get.snackbar('Error', 'Failed to start voice chat');
    }
  }

  Future<void> stopVoiceChat() async {
    await _speechService.stopVoiceChat();
    isListening.value = false;
  }

  @override
  void onClose() {
    _speechService.dispose();
    super.onClose();
  }
}
