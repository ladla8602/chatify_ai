import 'package:chatify_ai/models/image_gen_command.dart';
import 'package:chatify_ai/models/image_message.model.dart';
import 'package:chatify_ai/services/firebase_functions_service.dart';
import 'package:chatify_ai/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:chatify_ai/library/flutter_chat/lib/src/types/types.dart'
    as types;

import '../constants/constants.dart';

class ImageGenController extends GetxController {
  // Dependencies
  final FirestoreService _firestoreService;
  final FirebaseFunctionsService _firebaseFunctionsService;

  ImageGenController({
    FirestoreService? firestoreService,
    FirebaseFunctionsService? firebaseFunctionsService,
  })  : _firestoreService = firestoreService ?? FirestoreService(),
        _firebaseFunctionsService =
            firebaseFunctionsService ?? FirebaseFunctionsService();

  // UI Controllers
  final messageController = TextEditingController();

  // Observables
  final messages = <types.Message>[].obs;
  final typingUsers = <types.User>[].obs;
  final isDataLoadingForFirstTime = true.obs;
  final user = types.User(id: FirebaseAuth.instance.currentUser!.uid);
  late GlobalKey<FormState> imageGenFormKey;
  ImageGenCommand imageGenCommand = ImageGenCommand();
  DocumentSnapshot? lastDocument;

  List<Map<String, dynamic>> imageGenerate = [
    {
      'title': 'anime'.tr,
      'color': ColorConstant.primaryColor,
      'imagePath':
          'https://img.freepik.com/free-photo/woman-with-bird-her-back-forest_23-2151835204.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'audioPath': 'voices/anime.mp3',
    },
    {
      'title': 'low_poly'.tr,
      'color': ColorConstant.primaryColor,
      'imagePath':
          'https://img.freepik.com/free-photo/3d-portrait-people_23-2150793921.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'audioPath': 'voices/loy-poly.mp3',
    },
    {
      'title': 'fantastic'.tr,
      'color': ColorConstant.primaryColor,
      'imagePath':
          'https://img.freepik.com/premium-photo/astral-ambassador-superhuman-diplomat-other-realms_839035-556669.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'audioPath': 'voices/Fantastic.mp3',
    }
  ];

  var isSelected = 0.obs;

  void changeSelected(int index) {
    isSelected.value = index;
  }

  Future<void> loadInitialMessages() async {
    try {
      await _loadHistoricalMessages();
    } catch (e) {
      print('Error loading messages: $e');
    } finally {
      isDataLoadingForFirstTime.value = false;
    }
  }

  Future<void> _loadHistoricalMessages() async {
    final snapshot = await _fetchMessages();
    if (snapshot.docs.isEmpty) return;

    final chatMessages = _convertFirestoreToMessages(snapshot.docs);
    messages.assignAll(chatMessages);
    lastDocument = snapshot.docs.last;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _fetchMessages() {
    return lastDocument == null
        ? _firestoreService.fetchImageMessages()
        : _firestoreService.fetchImageMessages(lastDocument);
  }

  List<types.Message> _convertFirestoreToMessages(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return docs.expand((doc) {
      final message = ImageMessage.fromFirestore(doc);
      return _createMessagesFromChatMessage(message);
    }).toList();
  }

  List<types.Message> _createMessagesFromChatMessage(ImageMessage message) {
    final messages = <types.Message>[];

    messages.add(_createImageMessage(message));

    return messages;
  }

  types.Message _createImageMessage(ImageMessage message) {
    return types.ImageMessage(
      author: user,
      createdAt:
          DateTime.parse(message.createdAt.toString()).millisecondsSinceEpoch,
      id: message.id.toString(),
      name: 'AI Generated Image',
      size: 1024,
      type: types.MessageType.image,
      showStatus: true,
      uri: message.imgUrl.toString(),
    );
  }

  void handleSendPressed() {
    //TODO: Implement api call here to get generated image
  }
}
