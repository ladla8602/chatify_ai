import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:chatify_ai/models/chat_bot_command.model.dart';
import 'package:chatify_ai/models/chatbot.model.dart';
import 'package:chatify_ai/library/flutter_chat/lib/src/types/types.dart' as types;
import 'package:chatify_ai/services/firestore_service.dart';

class ChatController extends GetxController {
  // Controllers
  final TextEditingController messageController = TextEditingController();

  // Observables
  final RxList<types.Message> messages = <types.Message>[].obs;
  final RxList<types.User> typingUsers = <types.User>[].obs;
  final RxBool isDataLoadingForFirstTime = true.obs;

  // State
  ChatBot? chatbot;
  String? chatBotId;
  types.User? user;
  final ChatBotCommand chatBotCommand = ChatBotCommand();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void onInit() {
    super.onInit();
    _loadInitialMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  Future<void> _loadInitialMessages() async {
    try {
      if (chatBotId != null) {
        // final historicalMessages = await _firestoreService.getChatHistory(chatBotId!);
        // messages.assignAll(historicalMessages);
      }
      isDataLoadingForFirstTime.value = false;
    } catch (e) {
      log('Error loading messages: $e');
      isDataLoadingForFirstTime.value = false;
    }
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _addMessage(textMessage);
    _processBotResponse(message.text);
  }

  Future<void> _processBotResponse(String userMessage) async {
    try {
      _showTypingIndicator();
      await Future.delayed(const Duration(seconds: 4));
      // final response = await _firestoreService.getBotResponse(
      //   chatBotId!,
      //   chatBotCommand.copyWith(message: userMessage),
      // );

      // if (response != null) {
      //   final botMessage = types.TextMessage(
      //     author: types.User(
      //       id: "bot",
      //       firstName: chatbot?.botName,
      //     ),
      //     id: const Uuid().v4(),
      //     text: response,
      //     createdAt: DateTime.now().millisecondsSinceEpoch,
      //   );
      //   _addMessage(botMessage);
      // }
    } catch (e) {
      log('Error processing bot response: $e');
    } finally {
      _removeTypingIndicator();
    }
  }

  void _addMessage(types.Message message) {
    messages.insert(0, message);
    // _firestoreService.saveMessage(chatBotId!, message);
  }

  void sendMessage() {
    log(messageController.text);
    if (messageController.text.isEmpty) return;
    if (user == null || chatBotId == null) return;
    log(">>>>>>>>>>>");
    final message = types.PartialText(text: messageController.text);
    messageController.clear();
    handleSendPressed(message);
  }

  void _showTypingIndicator() {
    if (chatbot?.botName == null) return;
    typingUsers.insert(
      0,
      types.User(id: "bot", firstName: chatbot?.botName),
    );
  }

  void _removeTypingIndicator() {
    typingUsers.removeWhere((user) => user.id == "bot");
  }

  void clearChatContext() {
    messages.clear();
    typingUsers.clear();
    messageController.clear();
    chatBotCommand.prompt = null;
    user = null;
    chatbot = null;
    chatBotId = null;
  }
}
