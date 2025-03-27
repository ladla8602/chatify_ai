import 'package:cloud_firestore/cloud_firestore.dart';

class ImageMessage {
  final String? id;
  final String userId;
  String imgUrl;
  final DateTime createdAt;
  final ImageMetadata? metadata;

  ImageMessage({
    this.id,
    required this.userId,
    required this.imgUrl,
    required this.createdAt,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'imgUrl': imgUrl,
      'createdAt': createdAt,
      'metadata': metadata?.toMap(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'imgUrl': imgUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'metadata': metadata?.toFirestore(),
    };
  }

  factory ImageMessage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ImageMessage(
      id: doc.id,
      userId: data['userId'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      metadata: data['metadata'] != null ? ImageMetadata.fromMap(data['metadata']) : null,
    );
  }

  ImageMessage copyWith({
    String? userId,
    String? imgUrl,
    DateTime? createdAt,
    ImageMetadata? metadata,
  }) {
    return ImageMessage(
      userId: userId ?? this.userId,
      imgUrl: imgUrl ?? this.imgUrl,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

class ImageMetadata {
  final String prompt;
  final String model;
  final String size;
  final String quality;

  ImageMetadata({
    required this.prompt,
    required this.model,
    required this.size,
    required this.quality,
  });

  Map<String, dynamic> toMap() {
    return {
      'prompt': prompt,
      'model': model,
      'size': size,
      'quality': quality,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'prompt': prompt,
      'model': model,
      'size': size,
      'quality': quality,
    };
  }

  factory ImageMetadata.fromMap(Map<String, dynamic> data) {
    return ImageMetadata(
      prompt: data['prompt'] ?? '',
      model: data['model'] ?? '',
      size: data['size'] ?? '',
      quality: data['quality'] ?? '',
    );
  }
}
