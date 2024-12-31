import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/models/chat_bot_command.model.dart';
import 'package:chatify_ai/models/chat_message.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirestoreService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchChatbots() {
    return _firestore.collection(FirebasePaths.chatBotsName).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchChatRoomMessages(
    String chatRoomId, [
    DocumentSnapshot? startAfter,
  ]) {
    final CollectionReference<Map<String, dynamic>> collection = _firestore.collection(FirebasePaths.chatRoomMessages(chatRoomId));

    Query<Map<String, dynamic>> query = collection;

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    return query.limit(10).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchChatRooms([
    DocumentSnapshot? startAfter,
  ]) {
    if (currentUser == null) {
      throw UnauthorizedException();
    }

    var query = _firestore.collection(FirebasePaths.chatRoomsName).where("userId", isEqualTo: currentUser!.uid).limit(10);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    return query.snapshots();
  }

  Future<void> createChatRoom(ChatBotCommand command) async {
    if (currentUser == null) {
      throw UnauthorizedException();
    }

    try {
      await _firestore.collection(FirebasePaths.chatRoomsName).doc(command.chatRoomId).set(_createChatRoomData(command));
    } catch (e) {
      throw FirestoreException('Error creating chat room: $e');
    }
  }

  Map<String, dynamic> _createChatRoomData(ChatBotCommand command) {
    return {
      'userId': currentUser!.uid,
      'botId': command.chatBotId,
      'botName': command.chatBotName,
      'botAvatar': command.chatBotAvatar,
      'createdAt': DateTime.now(),
    };
  }

  Future<void> updateChatRoomLastMessage(
    ChatBotCommand command,
    String botResponse,
  ) async {
    if (currentUser == null) {
      throw UnauthorizedException();
    }

    try {
      await _firestore.collection(FirebasePaths.chatRoomsName).doc(command.chatRoomId).update({
        'lastMessage': {
          "senderId": command.chatBotId,
          "content": botResponse,
          "timestamp": DateTime.now(),
        },
      });
    } catch (e) {
      throw FirestoreException('Error updating last message: $e');
    }
  }

  Future<void> storeChatRoomMessage(
    ChatBotCommand command,
    String botResponse,
  ) async {
    if (currentUser == null) {
      throw UnauthorizedException();
    }

    try {
      if (command.roomExist == false) {
        await createChatRoom(command);
      }

      final messagesCollection = _firestore.collection(
        FirebasePaths.chatRoomMessages(command.chatRoomId.toString()),
      );

      await Future.wait([
        messagesCollection.add(_createUserMessage(command).toFirestore()),
        messagesCollection.add(_createBotMessage(command, botResponse).toFirestore()),
        updateChatRoomLastMessage(command, botResponse),
      ]);
    } catch (e) {
      throw FirestoreException('Error storing chat messages: $e');
    }
  }

  ChatMessage _createUserMessage(ChatBotCommand command) {
    return ChatMessage(
      content: command.message!,
      timestamp: DateTime.now(),
      senderId: currentUser!.uid,
      senderType: "user",
      status: "delivered",
      type: "text",
    );
  }

  ChatMessage _createBotMessage(ChatBotCommand command, String response) {
    return ChatMessage(
      content: response,
      timestamp: DateTime.now().add(Duration(seconds: 1)),
      senderId: command.chatBotId ?? "bot",
      senderType: "bot",
      status: "delivered",
      type: "text",
    );
  }
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'User not authenticated']);
}

class FirestoreException implements Exception {
  final String message;
  FirestoreException(this.message);
}
