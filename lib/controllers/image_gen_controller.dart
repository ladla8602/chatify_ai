import 'dart:async';

import 'package:chatify_ai/library/flutter_chat/lib/src/types/types.dart' as types;
import 'package:chatify_ai/models/image_gen_command.dart';
import 'package:chatify_ai/models/image_message.model.dart';
import 'package:chatify_ai/services/firebase_functions_service.dart';
import 'package:chatify_ai/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageGenController extends GetxController {
  // Dependencies
  final FirestoreService _firestoreService;
  final FirebaseFunctionsService _firebaseFunctionsService;

  ImageGenController({
    FirestoreService? firestoreService,
    FirebaseFunctionsService? firebaseFunctionsService,
  })  : _firestoreService = firestoreService ?? FirestoreService(),
        _firebaseFunctionsService = firebaseFunctionsService ?? FirebaseFunctionsService();

  // UI Controllers
  final messageController = TextEditingController();

  // Observables
  final messages = <types.Message>[].obs;
  final typingUsers = <types.User>[].obs;
  final isDataLoadingForFirstTime = true.obs;
  final isGenerating = false.obs;
  final user = types.User(id: FirebaseAuth.instance.currentUser!.uid);
  late GlobalKey<FormState> imageGenFormKey;
  ImageGenCommand imageGenCommand = ImageGenCommand();
  DocumentSnapshot? lastDocument;
  final RxBool isDrawerOpen = false.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void toggleDrawer() {
    if (scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      Get.back();
      isDrawerOpen.value = false;
    } else {
      scaffoldKey.currentState?.openEndDrawer();
      isDrawerOpen.value = true;
    }
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
    return lastDocument == null ? _firestoreService.fetchImageMessages() : _firestoreService.fetchImageMessages(lastDocument);
  }

  List<types.Message> _convertFirestoreToMessages(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
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
      createdAt: DateTime.parse(message.createdAt.toString()).millisecondsSinceEpoch,
      id: message.id.toString(),
      name: 'AI Generated Image',
      size: 1024,
      type: types.MessageType.image,
      showStatus: true,
      uri: message.imgUrl.toString(),
    );
  }

  void handleSendPressed() {
    isGenerating.value = true;
    imageGenCommand.style = 'natural';
    _firebaseFunctionsService.generateAIImage(imageGenCommand).then((value) {
      final imageMessage = ImageMessage(
        userId: FirebaseAuth.instance.currentUser!.uid,
        imgUrl: value,
        createdAt: DateTime.now(),
        metadata: ImageMetadata(
          prompt: imageGenCommand.prompt!,
          model: imageGenCommand.model!,
          size: imageGenCommand.size!,
          quality: imageGenCommand.quality!,
        ),
      );
      messages.insert(0, _createImageMessage(imageMessage));
      isGenerating.value = false;
      toggleDrawer();
      unawaited(_firestoreService.storeImageMessage(imageMessage));
    }).catchError((e) {
      isGenerating.value = false;
      Get.snackbar('Error', e.toString());
    });
  }
}
