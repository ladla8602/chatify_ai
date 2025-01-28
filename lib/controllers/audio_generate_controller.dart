import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatify_ai/models/speech_command_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:chatify_ai/library/flutter_chat/lib/src/types/types.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatify_ai/library/flutter_chat/lib/src/types/types.dart'
    as types;
import '../models/audio_gen_model.dart';
import '../services/firebase_functions_service.dart';
import '../services/firestore_service.dart';

class AudioGenerateController extends GetxController {
  List<Map<String, dynamic>> audioGenerate = [
    {
      'title': 'Alloy',
      'imagePath':
          'https://img.freepik.com/premium-photo/male-models-photo-album-with-full-menly-vibes-from-all-world_563241-20905.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'voice': 'alloy'
    },
    {
      'title': 'Echo',
      'imagePath':
          'https://img.freepik.com/premium-photo/beautiful-egirl-woman-portrait_691560-641.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'voice': 'echo'
    },
    {
      'title': 'Fable',
      'imagePath':
          'https://img.freepik.com/premium-photo/cyberpunk-aesthetic-portrait-concept_659788-13875.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'voice': 'fable'
    },
    {
      'title': 'Onyx',
      'imagePath':
          'https://img.freepik.com/premium-photo/man-with-pair-goggles-his-face_910054-17592.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'voice': 'onyx'
    },
    {
      'title': 'Nova',
      'imagePath':
          'https://img.freepik.com/premium-photo/cybersecurity-style-man_664559-162.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid',
      'voice': 'nova'
    },
  ];

  final FirestoreService _firestoreService;
  final FirebaseFunctionsService _firebaseFunctionsService;
  final audioPlayer = AudioPlayer();
  SpeechCommand speechGenCommand = SpeechCommand();

  AudioGenerateController({
    FirestoreService? firestoreService,
    FirebaseFunctionsService? firebaseFunctionsService,
  })  : _firestoreService = firestoreService ?? FirestoreService(),
        _firebaseFunctionsService =
            firebaseFunctionsService ?? FirebaseFunctionsService();

  // UI Controllers
  final TextEditingController promptController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Observables
  final messages = <types.Message>[].obs;
  final typingUsers = <types.User>[].obs;
  final isDataLoadingForFirstTime = true.obs;
  final isGenerating = false.obs;
  final isSelected = 0.obs;
  final isDrawerOpen = false.obs;
  final isPlaying = false.obs;
  final currentPlayingUrl = ''.obs;
  final user = types.User(id: FirebaseAuth.instance.currentUser!.uid);
  DocumentSnapshot? lastDocument;

  // Audio Generation Options

  @override
  void onInit() {
    super.onInit();
    loadInitialMessages();
    setupAudioPlayerListeners();
  }

  @override
  void onClose() {
    promptController.dispose();
    audioPlayer.dispose();
    super.onClose();
  }

  void setupAudioPlayerListeners() {
    audioPlayer.onPlayerComplete.listen((event) {
      isPlaying.value = false;
      currentPlayingUrl.value = '';
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });
  }

  void changeSelected(int index) {
    isSelected.value = index;
  }

  void toggleDrawer() {
    if (scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      Get.back();
      isDrawerOpen.value = false;
    } else {
      scaffoldKey.currentState?.openEndDrawer();
      isDrawerOpen.value = true;
    }
  }

  Future<void> playAudio(String url) async {
    try {
      if (currentPlayingUrl.value == url && isPlaying.value) {
        await audioPlayer.pause();
        isPlaying.value = false;
      } else {
        if (currentPlayingUrl.value != url) {
          await audioPlayer.stop();
          await audioPlayer.setSource(UrlSource(url));
        }
        await audioPlayer.resume();
        currentPlayingUrl.value = url;
        isPlaying.value = true;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to play audio: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loadInitialMessages() async {
    try {
      await _loadHistoricalMessages();
    } catch (e) {
      print('Error loading messages: $e');
      Get.snackbar(
        'Error',
        'Failed to load audio history',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isDataLoadingForFirstTime.value = false;
    }
  }

  Future<void> _loadHistoricalMessages() async {
    final snapshot = await _fetchMessages();
    if (snapshot.docs.isEmpty) return;

    final audioMessages =
        snapshot.docs.map((doc) => AudioMessage.fromFirestore(doc)).toList();
    messages.assignAll(_convertToTypesMessages(audioMessages));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _fetchMessages() {
    return lastDocument == null
        ? _firestoreService.fetchAudioMessages()
        : _firestoreService.fetchAudioMessages(lastDocument);
  }

  Future<void> handleSendPressed() async {
    if (promptController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a prompt',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isGenerating.value = true;

      // Call the Firebase function to generate audio
      final value =
          await _firebaseFunctionsService.generateAudio(speechGenCommand);

      // Create an AudioMessage object
      final audioMessage = AudioMessage(
        userId: FirebaseAuth.instance.currentUser!.uid,
        audioUrl: value, // Ensure this is a valid URL string
        createdAt: DateTime.now(),
        prompt: speechGenCommand.text ?? '', // Use empty string if null
        voiceId: speechGenCommand.voice ?? 'alloy', // Default to 'alloy'
        duration: 0, // Update duration if available
      );

      // Add the new message to the UI
      // messages.insert(0, _convertToTypesMessages(audioMessage));
      messages.insert(0, _convertToTypesMessages(audioMessage).first);

      // Store the audio message in Firestore
      unawaited(_firestoreService.storeAudioMessage(audioMessage));

      // Update the UI and clear the prompt
      isGenerating.value = false;
      toggleDrawer(); // Open the history drawer
      promptController.clear();
    } catch (e) {
      print('>>>>>>>>$e');
      Get.snackbar(
        'Error',
        'Failed to generate audio: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isGenerating.value = false;
    }
  }

  List<types.CustomMessage> _convertToTypesMessages(dynamic input) {
    // Handle single AudioMessage or list of AudioMessages
    final messages = input is List<AudioMessage> ? input : [input];

    return messages.map((message) {
      return types.CustomMessage(
        author: user,
        createdAt: message.createdAt.millisecondsSinceEpoch,
        id: message.id,
        metadata: {
          'url': message.audioUrl,
          'duration': message.duration,
          'prompt': message.prompt,
          'voiceId': message.voiceId,
        },
        type: types.MessageType.custom,
      );
    }).toList();
  }
}
