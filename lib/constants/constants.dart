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
  static const String chatBotsName = 'chatBots';
  static const String chatRoomsName = 'chatRooms';
  static const String usersName = 'users';
  static const String messagesName = 'messages';
  static const String settingsName = 'settings';

  // For nested collections
  static String chatRooms(String chatRoomId) => 'chatRooms/$chatRoomId';
  static String chatRoomMessages(String chatRoomId) => 'chatRooms/$chatRoomId/messages';
}
