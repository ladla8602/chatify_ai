import 'dart:async';
import 'dart:developer';

import 'package:chatify_ai/models/chat_bot_command.model.dart';
import 'package:chatify_ai/models/image_gen_command.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class FirebaseFunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<String> askChatGPT(ChatBotCommand chatBotCommand) async {
    try {
      final response =
          await _functions.httpsCallable('askChatGPT', options: HttpsCallableOptions(timeout: Duration(seconds: 120))).call(chatBotCommand.toJson());
      // log(">>>>>>generateAiResponse:${response.data.toString()}");

      return response.data['message'];
    } catch (e) {
      debugPrint("Error occurred while calling Firebase functions: $e");
      return 'Opps something went wrong';
    }
  }

  Future<String> generateAIImage(ImageGenCommand imageGenCommand) async {
    try {
      final response =
          await _functions.httpsCallable('generateAIImage', options: HttpsCallableOptions(timeout: Duration(seconds: 120))).call(imageGenCommand.toJson());
      log(">>>>>>generateAiResponse:${response.data.toString()}");

      return response.data['image'];
    } catch (e) {
      debugPrint("Error occurred while calling Firebase functions: $e");
      return 'Opps something went wrong';
    }
  }
}
