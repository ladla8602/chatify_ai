import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/models/chat_bot_command.model.dart';
import 'package:chatify_ai/models/chat_message.model.dart';
import 'package:chatify_ai/models/image_message.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../models/audio_gen_model.dart';

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
    final CollectionReference<Map<String, dynamic>> collection =
        _firestore.collection(FirebasePaths.chatRoomMessages(chatRoomId));

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

    var query = _firestore
        .collection(FirebasePaths.chatRoomsName)
        .where("userId", isEqualTo: currentUser!.uid)
        .limit(10);

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
      await _firestore
          .collection(FirebasePaths.chatRoomsName)
          .doc(command.chatRoomId)
          .set(_createChatRoomData(command));
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
      await _firestore
          .collection(FirebasePaths.chatRoomsName)
          .doc(command.chatRoomId)
          .update({
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
        messagesCollection
            .add(_createBotMessage(command, botResponse).toFirestore()),
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

  // Image Generation
  Future<QuerySnapshot<Map<String, dynamic>>> fetchImageMessages([
    DocumentSnapshot? startAfter,
  ]) {
    if (currentUser == null) {
      throw UnauthorizedException();
    }
    final CollectionReference<Map<String, dynamic>> collection =
        _firestore.collection(FirebasePaths.generatedImageName);

    Query<Map<String, dynamic>> query =
        collection.where("userId", isEqualTo: currentUser!.uid);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    return query.limit(10).get();
  }

  Future<void> storeImageMessage(ImageMessage imageMessage) async {
    if (currentUser == null) {
      throw UnauthorizedException();
    }

    // Upload to firebase storage
    try {
      final response = await http.get(Uri.parse(imageMessage.imgUrl));
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image.png');
      await tempFile.writeAsBytes(response.bodyBytes);

      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef
          .child('ai-images/${DateTime.now().millisecondsSinceEpoch}.png');
      await imageRef.putFile(tempFile);
      imageMessage.imgUrl = await imageRef.getDownloadURL();
    } catch (e) {
      throw FirestoreException('Error uploading image: ${e.toString()}');
    }

    // Store in firestore
    try {
      await _firestore
          .collection(FirebasePaths.generatedImageName)
          .add(imageMessage.toFirestore());
    } catch (e) {
      throw FirestoreException('Error storing image message: $e');
    }
  }

  //audio generated
  Future<void> storeAudioMessage(AudioMessage audiomessage) async {
    try {
      // Download the audio file from the URL
      final response = await http.get(Uri.parse(audiomessage.audioUrl));

      // Ensure that the response is valid
      if (response.statusCode != 200) {
        throw Exception('Failed to download audio');
      }

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_audio.mp3');

      await tempFile.writeAsBytes(response.bodyBytes);

      final storageRef = FirebaseStorage.instance.ref();
      final audioRef = storageRef
          .child('ai-audio/${DateTime.now().millisecondsSinceEpoch}.mp3');

      await audioRef.putFile(tempFile);

      audiomessage.audioUrl = await audioRef.getDownloadURL();
    } catch (e) {
      // Throw a FirestoreException with detailed error message
      throw Exception('Error uploading audio: ${e.toString()}');
    }

    try {
      await _firestore
          .collection(FirebasePaths.generatedAudioName)
          .add(audiomessage.toFirestore());
    } catch (e) {
      throw Exception(
          'Error storing audio message in Firestore: ${e.toString()}');
    }
  }

  // Fetch audio messages from Firestore with pagination
  Future<QuerySnapshot<Map<String, dynamic>>> fetchAudioMessages(
      [DocumentSnapshot? lastDocument]) async {
    var query = _firestore
        .collection(FirebasePaths.generatedAudioName)
        .orderBy('createdAt', descending: true)
        .limit(20);

    // If a last document is provided, use it for pagination
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    try {
      return await query.get(); // Fetch the query result
    } catch (e) {
      // Handle any query errors
      throw Exception('Error fetching audio messages: ${e.toString()}');
    }
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
