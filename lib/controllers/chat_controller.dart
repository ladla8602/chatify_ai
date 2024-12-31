import 'dart:developer';
import 'package:chatify_ai/models/chat_message.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? chatRoomId;
  types.User? user;
  ChatBotCommand chatBotCommand = ChatBotCommand();
  DocumentSnapshot? lastDocument;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void onInit() {
    super.onInit();
    loadInitialMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  Future<void> loadInitialMessages() async {
    try {
      if (chatRoomId != null) {
        // final historicalMessages = await _firestoreService.getChatHistory(chatBotId!);
        // messages.assignAll(historicalMessages);
        await _handleEndReached();
      } else {
        final message = types.Message.fromJson({
          "author": {"firstName": chatbot?.botName, "id": "0", "lastName": ""},
          "createdAt": DateTime.now().millisecondsSinceEpoch,
          "id": "0",
          "remoteId": "0",
          "text": chatbot?.botMessage ?? 'Hi there! How can I help you?',
          "type": "text"
        });
        _addMessage(message);
      }
      isDataLoadingForFirstTime.value = false;
    } catch (e) {
      log('Error loading messages: $e');
      isDataLoadingForFirstTime.value = false;
    }
  }

  Future<void> _handleEndReached() async {
    if (chatBotCommand.chatRoomId == null) {
      return;
    }
    //Fetch messages from Firestore with pagination
    QuerySnapshot<Map<String, dynamic>> snapshot;
    if (lastDocument == null) {
      snapshot = await _firestoreService.fetchChatRoomMessages(chatBotCommand.chatRoomId!);
    } else {
      snapshot = await _firestoreService.fetchChatRoomMessages(chatBotCommand.chatRoomId!, lastDocument);
    }
    if (snapshot.docs.isNotEmpty) {
      List<ChatMessage> data = snapshot.docs.map((doc) {
        // Assuming ChatMessage has a constructor from a map
        return ChatMessage.fromFirestore(doc);
      }).toList();

      List<types.Message> messages = [];
      for (var message in data) {
        if (message.vision != null) {
          final textMsg = types.Message.fromJson({
            "author": {"firstName": chatbot?.botName, "id": message.senderType == 'user' ? message.senderId.toString() : "0", "lastName": ""},
            "createdAt": message.timestamp.millisecondsSinceEpoch,
            "id": message.id.toString(),
            "text": message.content,
            "type": "text",
          });
          messages.add(textMsg);
          if (message.vision!.mimeType == 'application/pdf' || message.vision!.mimeType == 'application/octet-stream') {
            final visionMsg = types.FileMessage(
              author: user!,
              createdAt: message.timestamp.millisecondsSinceEpoch,
              id: message.vision!.id!,
              remoteId: message.id,
              name: message.vision!.fileName ?? "PDF File",
              size: num.parse(message.vision!.size!),
              uri: message.vision!.uri.toString(),
            );
            messages.add(visionMsg);
          } else {
            final visionMsg = types.ImageMessage(
              author: user!,
              createdAt: message.timestamp.millisecondsSinceEpoch,
              id: message.vision!.id!,
              remoteId: message.id,
              name: "Vision Message",
              size: num.parse(message.vision!.size!),
              uri: message.vision!.uri.toString(),
            );
            messages.add(visionMsg);
          }
        } else {
          final textMsg = types.Message.fromJson({
            "author": {"firstName": chatbot?.botName, "id": message.senderType == 'user' ? message.senderId.toString() : "0", "lastName": ""},
            "createdAt": message.timestamp.millisecondsSinceEpoch,
            "id": message.id.toString(),
            "text": message.content,
            "type": "text",
          });
          messages.add(textMsg);
        }
      }

      // if (isMessageUnique(message)) {
      if (data.isNotEmpty) {
        messages = [...messages, ...messages];
        // _page = _page + 1;
        lastDocument = snapshot.docs.last;
      }
      isDataLoadingForFirstTime.value = false;
      // }
    } else {
      // unawaited(Fluttertoast.showToast(msg: Trans.current.something_went_wrong));
    }
    isDataLoadingForFirstTime.value = false;
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
    if (user == null) return;
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
    chatBotCommand = ChatBotCommand();
    user = null;
    chatbot = null;
    chatRoomId = null;
  }
}
