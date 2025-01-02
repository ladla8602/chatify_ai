import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatify_ai/models/chat_message.model.dart';
import 'package:chatify_ai/models/chat_bot_command.model.dart';
import 'package:chatify_ai/models/chatbot.model.dart';
import 'package:chatify_ai/services/firebase_functions_service.dart';
import 'package:chatify_ai/services/firestore_service.dart';
import 'package:chatify_ai/library/flutter_chat/lib/src/types/types.dart'
    as types;

class ChatController extends GetxController {
  // Dependencies
  final FirestoreService _firestoreService;
  final FirebaseFunctionsService _firebaseFunctionsService;

  ChatController({
    FirestoreService? firestoreService,
    FirebaseFunctionsService? firebaseFunctionsService,
  })  : _firestoreService = firestoreService ?? FirestoreService(),
        _firebaseFunctionsService =
            firebaseFunctionsService ?? FirebaseFunctionsService();

  // UI Controllers
  final messageController = TextEditingController();

  // Observables
  final messages = <types.Message>[].obs;
  final typingUsers = <types.User>[].obs;
  final isDataLoadingForFirstTime = true.obs;

  // State
  ChatBot? chatbot;
  types.User? user;
  ChatBotCommand chatBotCommand = ChatBotCommand();
  DocumentSnapshot? lastDocument;

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  Future<void> loadInitialMessages() async {
    try {
      if (chatBotCommand.roomExist == true) {
        await _loadHistoricalMessages();
      } else {
        _addWelcomeMessage();
      }
    } catch (e) {
      log('Error loading messages: $e');
    } finally {
      isDataLoadingForFirstTime.value = false;
    }
  }

  Future<void> _loadHistoricalMessages() async {
    if (chatBotCommand.chatRoomId == null) return;

    final snapshot = await _fetchMessages();
    if (snapshot.docs.isEmpty) return;

    final chatMessages = _convertFirestoreToMessages(snapshot.docs);
    messages.assignAll(chatMessages);
    lastDocument = snapshot.docs.last;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _fetchMessages() {
    return lastDocument == null
        ? _firestoreService.fetchChatRoomMessages(chatBotCommand.chatRoomId!)
        : _firestoreService.fetchChatRoomMessages(
            chatBotCommand.chatRoomId!, lastDocument);
  }

  List<types.Message> _convertFirestoreToMessages(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return docs.expand((doc) {
      final message = ChatMessage.fromFirestore(doc);
      return _createMessagesFromChatMessage(message);
    }).toList();
  }

  List<types.Message> _createMessagesFromChatMessage(ChatMessage message) {
    final messages = <types.Message>[];

    messages.add(_createTextMessage(message));
    if (message.vision != null) {
      messages.add(_createMediaMessage(message));
    }

    return messages;
  }

  types.Message _createTextMessage(ChatMessage message) {
    return types.Message.fromJson({
      "author": {
        "firstName":
            message.senderType == 'user' ? user?.firstName : chatbot?.botName,
        "id": message.senderId.toString(),
        "lastName": ""
      },
      "createdAt": message.timestamp.millisecondsSinceEpoch,
      "id": message.id.toString(),
      "text": message.content,
      "type": "text"
    });
  }

  types.Message _createMediaMessage(ChatMessage message) {
    final vision = message.vision!;
    final isPdf = vision.mimeType == 'application/pdf' ||
        vision.mimeType == 'application/octet-stream';

    return isPdf
        ? types.FileMessage(
            author: user!,
            createdAt: message.timestamp.millisecondsSinceEpoch,
            id: vision.id!,
            remoteId: message.id,
            name: vision.fileName ?? "PDF File",
            size: num.parse(vision.size!),
            uri: vision.uri.toString(),
          )
        : types.ImageMessage(
            author: user!,
            createdAt: message.timestamp.millisecondsSinceEpoch,
            id: vision.id!,
            remoteId: message.id,
            name: "Vision Message",
            size: num.parse(vision.size!),
            uri: vision.uri.toString(),
          );
  }

  void _addWelcomeMessage() {
    final welcomeMessage = types.Message.fromJson({
      "author": {
        "firstName": chatbot?.botName,
        "id": chatbot?.botId ?? "bot",
        "lastName": ""
      },
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "id": "0",
      "remoteId": "0",
      "text": chatbot?.botMessage ?? 'Hi there! How can I help you?',
      "type": "text"
    });
    _addMessage(welcomeMessage);
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = _createUserMessage(message.text);
    _addMessage(textMessage);
    _processBotResponse(message.text);
  }

  types.TextMessage _createUserMessage(String text) {
    return types.TextMessage(
      author: user!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      roomId: chatBotCommand.chatRoomId,
      text: text,
    );
  }

  Future<void> _processBotResponse(String userMessage) async {
    try {
      _showTypingIndicator();
      final response = await _firebaseFunctionsService
          .generateAiResponse(chatBotCommand as String);
      _addMessage(_createBotMessage(response));
    } catch (e) {
      log('Error processing bot response: $e');
    } finally {
      _removeTypingIndicator();
    }
  }

  String _formatContextForOpenAI() {
    final contextMessages = messages
        .take(3)
        .whereType<types.TextMessage>()
        .map((msg) {
          final role = msg.author.id == chatbot?.botId ? 'assistant' : 'user';
          return '{"role": "$role", "content": "${msg.text}"}';
        })
        .toList()
        .reversed;

    return '[${contextMessages.join(', ')}]';
  }

  types.TextMessage _createBotMessage(String text) {
    return types.TextMessage(
      author: types.User(
        id: chatbot?.botId ?? "bot",
        firstName: chatbot?.botName,
      ),
      id: const Uuid().v4(),
      text: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  void _addMessage(types.Message message) {
    messages.insert(0, message);
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final message = types.PartialText(text: messageController.text);
    messageController.clear();
    handleSendPressed(message);
  }

  void _showTypingIndicator() {
    if (chatbot?.botName == null) return;
    typingUsers.insert(0, types.User(id: "bot", firstName: chatbot?.botName));
  }

  void _removeTypingIndicator() {
    typingUsers.removeWhere((user) => user.id == "bot");
  }

  void clearChatContext() {
    messages.clear();
    typingUsers.clear();
    messageController.clear();
    chatBotCommand = ChatBotCommand();
    user = null;
    chatbot = null;
  }
}
