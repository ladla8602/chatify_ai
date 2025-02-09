import 'dart:async';
import 'dart:developer';

import 'package:chatify_ai/models/chat_bot_command.model.dart';
import 'package:chatify_ai/models/image_gen_command.dart';
import 'package:chatify_ai/models/subscription_plan.model.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import '../models/speech_command_model.dart';

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
      // log(">>>>>>generateAiResponse:${response.data.toString()}");

      return response.data['image'];
    } catch (e) {
      debugPrint("Error occurred while calling Firebase functions: $e");
      return 'Opps something went wrong';
    }
  }

  Future<String> generateAudio(SpeechCommand speechGenCommand) async {
    try {
      final response =
          await _functions.httpsCallable('generateSpeech', options: HttpsCallableOptions(timeout: Duration(seconds: 120))).call(speechGenCommand.toJson());
      // log(">>>>>>generateAudioAiResponse:${response.data.toString()}");

      return response.data['audioUrl'];
    } catch (e) {
      debugPrint("Error occurred while calling Firebase functions: $e");
      return 'Opps something went wrong';
    }
  }

  // WEB RTC
  Future<String> getVoiceChatToken() async {
    try {
      final response = await _functions.httpsCallable('getVoiceChatToken').call();
      print(">>>>>>getVoiceChatToken:${response.data.toString()}");
      if (response.data['success'] == true) {
        return response.data['token']['token'];
      }
      throw Exception(response.data['error'] ?? 'Failed to get token');
    } catch (e) {
      throw Exception('Error getting voice chat token: $e');
    }
  }

  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      final HttpsCallableResult<Map<String, dynamic>> response =
          await _functions.httpsCallable('getSubscriptionPlans', options: HttpsCallableOptions(timeout: Duration(seconds: 120))).call();

      final plansList = response.data['plans'];
      log(">>>>>>getSubscriptionPlans:${plansList.toString()}");
      return (plansList as List).map((item) {
        log("Plan item before conversion: $item");
        final planMap = Map<String, dynamic>.from(item).cast<String, dynamic>();
        log("Plan item after conversion: $planMap");
        return SubscriptionPlan.fromJson(planMap);
      }).toList();
    } catch (e) {
      debugPrint("Error occurred while calling Firebase functions: $e");
      throw Exception('Opps something went wrong: $e');
    }
  }

  Future<String> createSubscription(String priceId) async {
    try {
      final response =
          await _functions.httpsCallable('createSubscription', options: HttpsCallableOptions(timeout: Duration(seconds: 120))).call({"priceId": priceId});
      log(">>>>>>createSubscription:${response.data.toString()}");

      return response.data['clientSecret'];
    } catch (e) {
      debugPrint("Error occurred while calling Firebase functions: $e");
      throw Exception('Opps something went wrong: $e');
    }
  }
}
