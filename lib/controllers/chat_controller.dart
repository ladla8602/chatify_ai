import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/models/chatbot.model.dart';
import 'package:chatify_ai/services/chat_service.dart';
import 'package:chatify_ai/library/flutter_chat/lib/src/types/types.dart'
    as types;
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class ChatController extends GetxController {
  ChatService chatService = ChatService();
  // States
  final _chatbots = <ChatBot>[].obs;
  final _isLoading = false.obs;
  final _error = Rxn<String>();

  // Getters
  List<ChatBot> get chatbots => _chatbots;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  @override
  void onInit() {
    super.onInit();
    getChatbots();
  }

  Future<void> getChatbots({bool forceRefresh = false}) async {
    // Don't fetch if loading
    if (_isLoading.value) return;

    // Check cache if not force refresh
    // if (!forceRefresh) {
    //   final cached = GetStorage().read(FirebasePaths.chatBots);
    //   if (cached != null) {
    //     _chatbots.assignAll(List<ChatBot>.from((cached as List).map((x) => ChatBot.fromJson(x))));
    //     return;
    //   }
    // }

    _isLoading.value = true;
    _error.value = null;

    try {
      // Get fresh data
      final snapshot = await chatService.fetchChatbots();

      final data =
          snapshot.docs.map((doc) => ChatBot.fromFirestore(doc)).toList();

      // Update state and cache
      _chatbots.assignAll(data);
      await GetStorage()
          .write(FirebasePaths.chatBots, data.map((x) => x.toJson()).toList());
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void clearCache() {
    GetStorage().remove(FirebasePaths.chatBots);
    _chatbots.clear();
  }

  // Chat Content
  List<types.Message> messages = [];
  RxBool isDataLoadingForFirstTime = true.obs;

  void handleSendPressed(types.PartialText message, {String? remoteId}) {}

  void addMessage(types.Message message) {
    messages.insert(0, message);
    isDataLoadingForFirstTime.value = false;
  }

  void sendMessage() {}
}
