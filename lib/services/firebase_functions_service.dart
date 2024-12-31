import 'dart:convert';
import 'dart:developer';

import 'package:chatify_ai/models/chat_bot_command.model.dart';
import 'package:chatify_ai/services/firestore_service.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class FirebaseFunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirestoreService _firestoreService = FirestoreService();

  Future<String> generateAiResponse(ChatBotCommand chatBotCommand) async {
    try {
      final response =
          await _functions.httpsCallable('askChatGPT', options: HttpsCallableOptions(timeout: Duration(seconds: 120))).call(chatBotCommand.toJson());
      // log(">>>>>>generateAiResponse:${response.data.toString()}");
      _firestoreService.storeChatRoomMessage(chatBotCommand, response.data['message']);
      return response.data['message'];
    } catch (e) {
      debugPrint("Error occurred while calling Firebase functions: $e");
      return 'Opps something went wrong';
    }
  }
}
