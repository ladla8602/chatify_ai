import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String content;
  final DateTime timestamp;
  final String senderId;
  final String senderType;
  final String status;
  final String type;
  final MessageMetadata metadata;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.senderId,
    required this.senderType,
    required this.status,
    required this.type,
    required this.metadata,
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

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      senderId: data['senderId'] ?? '',
      senderType: data['senderType'] ?? 'user',
      status: data['status'] ?? 'sent',
      type: data['type'] ?? 'text',
      metadata: MessageMetadata.fromMap(data['metadata'] ?? {}),
    );
  }

  Message copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    String? senderId,
    String? senderType,
    String? status,
    String? type,
    MessageMetadata? metadata,
  }) {
    return Message(
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

class MessageMetadata {
  final int? tokens;
  final String? model;
  final String? error;

  MessageMetadata({
    this.tokens,
    this.model,
    this.error,
  });

  Map<String, dynamic> toMap() {
    return {
      'tokens': tokens,
      'model': model,
      'error': error,
    };
  }

  Map<String, dynamic> toFirestore() => toMap();

  factory MessageMetadata.fromMap(Map<String, dynamic> map) {
    return MessageMetadata(
      tokens: map['tokens'],
      model: map['model'],
      error: map['error'],
    );
  }
}
