import 'package:get/state_manager.dart';

class ChatController extends GetxController {
  // void sendMessage( message) async {
  //   // Add user message to Firestore
  //   final userMessage = types.TextMessage(
  //     author: _user,
  //     createdAt: DateTime.now().millisecondsSinceEpoch,
  //     id: UniqueKey().toString(),
  //     text: message.text,
  //   );

  //   FirebaseFirestore.instance
  //       .collection('chats')
  //       .doc('chat_room_id')
  //       .collection('messages')
  //       .add({
  //     'text': userMessage.text,
  //     'senderId': _user.id,
  //     'createdAt': FieldValue.serverTimestamp(),
  //   });

  //   setState(() {
  //     _messages.insert(0, userMessage);
  //   });

  //   final aiResponse = await _openAIService.getAIResponse(message.text);

  //   final aiMessage = types.TextMessage(
  //     author: _ai,
  //     createdAt: DateTime.now().millisecondsSinceEpoch,
  //     id: UniqueKey().toString(),
  //     text: aiResponse,
  //   );

  //   FirebaseFirestore.instance
  //       .collection('chats')
  //       .doc('chat_room_id')
  //       .collection('messages')
  //       .add({
  //     'text': aiMessage.text,
  //     'senderId': _ai.id,
  //     'createdAt': FieldValue.serverTimestamp(),
  //   });

  //   setState(() {
  //     _messages.insert(0, aiMessage);
  //   });
  // }
}
