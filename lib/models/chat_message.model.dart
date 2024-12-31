import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String content;
  final DateTime timestamp;
  final String senderId;
  final String senderType;
  final String status;
  final String type;
  final VisionChatMessage? vision;
  final MessageMetadata metadata;

  ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.senderId,
    required this.senderType,
    required this.status,
    required this.type,
    required this.metadata,
    this.vision,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp,
      'senderId': senderId,
      'senderType': senderType,
      'status': status,
      'type': type,
      'metadata': metadata.toMap(),
      'vision': vision?.toJson(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'senderId': senderId,
      'senderType': senderType,
      'status': status,
      'type': type,
      'metadata': metadata.toFirestore(),
    };
  }

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      senderId: data['senderId'] ?? '',
      senderType: data['senderType'] ?? 'user',
      status: data['status'] ?? 'sent',
      type: data['type'] ?? 'text',
      vision: data['vision'] != null ? VisionChatMessage.fromJson(data['vision']) : null,
      metadata: MessageMetadata.fromMap(data['metadata'] ?? {}),
    );
  }

  ChatMessage copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    String? senderId,
    String? senderType,
    String? status,
    String? type,
    MessageMetadata? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      senderId: senderId ?? this.senderId,
      senderType: senderType ?? this.senderType,
      status: status ?? this.status,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
    );
  }
}

class VisionChatMessage {
  String? id;
  String? messageId;
  String? mimeType;
  String? uri;
  String? size;
  String? fileName;

  VisionChatMessage({this.id, this.messageId, this.mimeType, this.uri, this.size, this.fileName});

  VisionChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    messageId = json['message_id'];
    mimeType = json['mime_type'];
    uri = json['uri'];
    size = json['size'];
    fileName = json['file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['message_id'] = messageId;
    data['mime_type'] = mimeType;
    data['uri'] = uri;
    data['size'] = size;
    data['file_name'] = fileName;
    return data;
  }
}

class MessageMetadata {
  final String? mimeType;
  final int? tokens;
  final String? model;
  final String? error;

  MessageMetadata({
    this.mimeType,
    this.tokens,
    this.model,
    this.error,
  });

  Map<String, dynamic> toMap() {
    return {
      'mimeType': mimeType,
      'tokens': tokens,
      'model': model,
      'error': error,
    };
  }

  Map<String, dynamic> toFirestore() => toMap();

  factory MessageMetadata.fromMap(Map<String, dynamic> map) {
    return MessageMetadata(
      mimeType: map['mimeType'],
      tokens: map['tokens'],
      model: map['model'],
      error: map['error'],
    );
  }
}
