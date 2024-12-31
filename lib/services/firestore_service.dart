import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/models/chat_bot_command.model.dart';
import 'package:chatify_ai/models/chat_message.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService() : _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchChatbots() async {
    return await _firestore.collection(FirebasePaths.chatBotsName).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchChatRoomMessages(String chatRoomId, [DocumentSnapshot? startAfter]) async {
    Query<Map<String, dynamic>> query = _firestore.collection(FirebasePaths.chatRoomMessages(chatRoomId));
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return await query.limit(10).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchChatRooms([DocumentSnapshot? startAfter]) {
    Query<Map<String, dynamic>> query = _firestore.collection(FirebasePaths.chatRoomsName);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return query.where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).limit(10).snapshots();
  }

  Future<void> createChatRoom(ChatBotCommand chatBotCommand) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user is currently authenticated.");
      }

      await _firestore.collection(FirebasePaths.chatRoomsName).doc(chatBotCommand.chatRoomId).set({
        'userId': user.uid,
        'botId': chatBotCommand.chatBotId,
        'botName': chatBotCommand.chatBotName,
        'createdAt': DateTime.now(),
      });
      print("Chatroom successfully written!");
    } catch (e) {
      print("Error writing Chatroom: $e");
    }
  }

  Future<void> updateChatRoomLastMessage(ChatBotCommand chatBotCommand, String botMessageResponse) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user is currently authenticated.");
      }

      await _firestore.collection(FirebasePaths.chatRoomsName).doc(chatBotCommand.chatRoomId).update({
        'lastMessage': {
          "senderId": chatBotCommand.chatBotId,
          "content": botMessageResponse,
          "timestamp": DateTime.now(),
        },
      });
      print("updateChatRoomLastMessage successfully written!");
    } catch (e) {
      print("Error writing updateChatRoomLastMessage: $e");
    }
  }

  // Store chat room messages
  Future<void> storeChatRoomMessage(ChatBotCommand chatBotCommand, String botMessageResponse) async {
    if (chatBotCommand.roomExist == false) {
      // Chatroom not exists so create new chatroom
      await createChatRoom(chatBotCommand);
    }
    final userMessage = ChatMessage(
      content: chatBotCommand.message!,
      timestamp: DateTime.now(),
      senderId: FirebaseAuth.instance.currentUser!.uid,
      senderType: "user",
      status: "delivered",
      type: "text",
    );
    final botMessage = ChatMessage(
      content: botMessageResponse,
      timestamp: DateTime.now().add(Duration(seconds: 1)),
      senderId: chatBotCommand.chatBotId ?? "bot",
      senderType: "bot",
      status: "delivered",
      type: "text",
    );
    _firestore.collection(FirebasePaths.chatRoomMessages(chatBotCommand.chatRoomId.toString()))
      ..add(userMessage.toFirestore())
      ..add(botMessage.toFirestore());
    updateChatRoomLastMessage(chatBotCommand, botMessageResponse);
  }
}
