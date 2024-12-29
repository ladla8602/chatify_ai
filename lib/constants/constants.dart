import 'package:flutter/material.dart';

class AppConstant {
  static final String messagesCollection = 'messages';
  static final String usersCollection = 'users';
}

class ColorConstant {
  static final Color backgroundColor = Colors.white;
  static final Color primaryColor = Color(0xff4CAF50);
}

class FirebasePaths {
  static const String chatBots = 'chatBots';
  static const String users = 'users';
  static const String messages = 'messages';
  static const String settings = 'settings';

  // For nested collections
  static String userChats(String userId) => 'users/$userId/chats';
  static String chatMessages(String chatId) => 'chats/$chatId/messages';
}
