import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final String userId;
  final String botId;
  final DateTime createdAt;
  final LastMessage lastMessage;
  final ChatRoomMetadata metadata;

  ChatRoom({
    required this.id,
    required this.userId,
    required this.botId,
    required this.createdAt,
    required this.lastMessage,
    required this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'botId': botId,
      'createdAt': createdAt,
      'lastMessage': lastMessage.toMap(),
      'metadata': metadata.toMap(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'botId': botId,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessage': lastMessage.toFirestore(),
      'metadata': metadata.toFirestore(),
    };
  }

  factory ChatRoom.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatRoom(
      id: doc.id,
      userId: data['userId'] ?? '',
      botId: data['botId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastMessage: LastMessage.fromMap(data['lastMessage'] ?? {}),
      metadata: ChatRoomMetadata.fromMap(data['metadata'] ?? {}),
    );
  }
}

class LastMessage {
  final String content;
  final DateTime timestamp;
  final String senderId;

  LastMessage({
    required this.content,
    required this.timestamp,
    required this.senderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'timestamp': timestamp,
      'senderId': senderId,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'senderId': senderId,
    };
  }

  factory LastMessage.fromMap(Map<String, dynamic> map) {
    return LastMessage(
      content: map['content'] ?? '',
      timestamp: map['timestamp'] is Timestamp ? (map['timestamp'] as Timestamp).toDate() : DateTime.now(),
      senderId: map['senderId'] ?? '',
    );
  }
}

class ChatRoomMetadata {
  final String? customInstructions;

  ChatRoomMetadata({
    this.customInstructions,
  });

  Map<String, dynamic> toMap() {
    return {
      'customInstructions': customInstructions,
    };
  }

  Map<String, dynamic> toFirestore() => toMap();

  factory ChatRoomMetadata.fromMap(Map<String, dynamic> map) {
    return ChatRoomMetadata(
      customInstructions: map['customInstructions'],
    );
  }
}
