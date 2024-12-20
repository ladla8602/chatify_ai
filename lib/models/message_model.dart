class Message {
  final String text;
  final String userId;
  final DateTime timestamp;

  Message({required this.text, required this.userId, required this.timestamp});

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'],
      userId: map['userId'],
      timestamp: (map['timestamp'] as DateTime).toLocal(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'userId': userId,
      'timestamp': timestamp,
    };
  }
}
