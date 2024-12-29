import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatBot {
  final String botName;
  final String botAvatar;
  final String botRole;
  final String botMessage;
  final String botPrompt;
  final String botStatus;
  final DateTime createdAt;

  ChatBot({
    required this.botName,
    required this.botAvatar,
    required this.botRole,
    required this.botMessage,
    required this.botPrompt,
    required this.botStatus,
    required this.createdAt,
  });

  // Create a copy of the object with updated fields
  ChatBot copyWith({
    String? botName,
    String? botAvatar,
    String? botRole,
    String? botMessage,
    String? botPrompt,
    String? botStatus,
    DateTime? createdAt,
  }) {
    return ChatBot(
      botName: botName ?? this.botName,
      botAvatar: botAvatar ?? this.botAvatar,
      botRole: botRole ?? this.botRole,
      botMessage: botMessage ?? this.botMessage,
      botPrompt: botPrompt ?? this.botPrompt,
      botStatus: botStatus ?? this.botStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'botName': botName,
      'botAvatar': botAvatar,
      'botRole': botRole,
      'botMessage': botMessage,
      'botPrompt': botPrompt,
      'botStatus': botStatus,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Convert from Map
  factory ChatBot.fromMap(Map<String, dynamic> map) {
    return ChatBot(
      botName: map['botName'] ?? '',
      botAvatar: map['botAvatar'] ?? '',
      botRole: map['botRole'] ?? '',
      botMessage: map['botMessage'] ?? '',
      botPrompt: map['botPrompt'] ?? '',
      botStatus: map['botStatus'] ?? 'inactive',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  // Convert to JSON string
  String toJson() => jsonEncode(toMap());

  // Create from JSON string
  factory ChatBot.fromJson(String source) => ChatBot.fromMap(json.decode(source));

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'botName': botName,
      'botAvatar': botAvatar,
      'botRole': botRole,
      'botMessage': botMessage,
      'botPrompt': botPrompt,
      'botStatus': botStatus,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory ChatBot.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ChatBot(
      botName: data['botName'] ?? '',
      botAvatar: data['botAvatar'] ?? '',
      botRole: data['botRole'] ?? '',
      botMessage: data['botMessage'] ?? '',
      botPrompt: data['botPrompt'] ?? '',
      botStatus: data['botStatus'] ?? 'inactive',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Override toString for debugging
  @override
  String toString() {
    return 'ChatBot(botName: $botName, botAvatar: $botAvatar, botRole: $botRole, botMessage: $botMessage, botPrompt: $botPrompt, botStatus: $botStatus, createdAt: $createdAt)';
  }
}
