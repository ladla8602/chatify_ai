import 'package:cloud_firestore/cloud_firestore.dart';

class AudioMessage {
  final String id;
  final String userId;
  String audioUrl;
  final DateTime createdAt;
  final String prompt;
  final String voiceId;
  final int duration;

  AudioMessage({
    String? id,
    required this.userId,
    required this.audioUrl,
    required this.createdAt,
    required this.prompt,
    required this.voiceId,
    required this.duration,
  }) : this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  factory AudioMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AudioMessage(
      id: doc.id,
      userId: data['userId'],
      audioUrl: data['audioUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      prompt: data['prompt'],
      voiceId: data['voiceId'],
      duration: data['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'audioUrl': audioUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'prompt': prompt,
      'voiceId': voiceId,
      'duration': duration,
    };
  }
}
