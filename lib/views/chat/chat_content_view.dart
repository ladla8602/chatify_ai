import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify_ai/library/flutter_chat/lib/flutter_chat.dart';
import 'package:chatify_ai/library/flutter_chat/lib/src/types/types.dart' as types;
import 'package:chatify_ai/models/chatbot.model.dart';
import 'package:chatify_ai/widgets/not_found_widget.dart';
import 'package:chatify_ai/widgets/typing_loader.dart';
import 'package:chatify_ai/controllers/chat_controller.dart';
import 'package:uuid/uuid.dart';

class ChatContentView extends StatefulWidget {
  const ChatContentView({super.key});

  @override
  State<ChatContentView> createState() => _ChatContentViewState();
}

class _ChatContentViewState extends State<ChatContentView> {
  final _focusNode = FocusNode();
  late ChatController _chatController;
  late final User? _currentUser;

  @override
  void initState() {
    super.initState();
    _chatController = Get.put(ChatController());
    _initializeChat();
  }

  void _initializeChat() {
    _currentUser = FirebaseAuth.instance.currentUser;
    final ChatBot chatbot = Get.arguments['chatbot'];

    _chatController
      ..chatbot = chatbot
      ..chatBotCommand.chatRoomId = Get.arguments['chatRoomId'] ?? Uuid().v4()
      ..chatBotCommand.roomExist = Get.arguments['chatRoomId'] != null
      ..chatBotCommand.chatBotId = chatbot.botId
      ..chatBotCommand.chatBotName = chatbot.botName
      ..chatBotCommand.chatBotAvatar = chatbot.botAvatar
      ..chatBotCommand.prompt = chatbot.botPrompt
      ..user = types.User(
        id: _currentUser!.uid,
        firstName: _currentUser.displayName,
        role: types.Role.user,
      );

    _chatController.loadInitialMessages();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _chatController.clearChatContext();
    Get.delete<ChatController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(context),
        body: _buildChatBody(context),
      );

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Row(
          children: [
            _buildAvatar(context),
            const SizedBox(width: 8),
            Text(
              _chatController.chatbot?.botName ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  Widget _buildAvatar(BuildContext context) => CircleAvatar(
        radius: 18,
        backgroundColor: Theme.of(context).primaryColor,
        child: CachedNetworkImage(
          imageUrl: _chatController.chatbot?.botAvatar ?? "http://via.placeholder.com/200x150",
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 16,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );

  Widget _buildChatBody(BuildContext context) => Obx(() => Chat(
        messages: _chatController.messages.toList(),
        onSendPressed: _chatController.handleSendPressed,
        user: _chatController.user!,
        showUserAvatars: false,
        showUserNames: true,
        usePreviewData: false,
        emptyState: _buildEmptyState(),
        typingIndicatorOptions: TypingIndicatorOptions(
          typingUsers: _chatController.typingUsers.toList(),
        ),
        customBottomWidget: _buildMessageInput(context),
      ));

  Widget _buildEmptyState() => Obx(() => _chatController.isDataLoadingForFirstTime.value
      ? const Center(child: TypingLoaderWidget())
      : NotFoundWidget(
          title: 'no_chat'.tr,
          onButtonClick: () => Navigator.of(context).pop(),
        ));

  Widget _buildMessageInput(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Flexible(
                child: _buildTextField(context),
              ),
              const SizedBox(width: 8),
              _buildSendButton(context),
            ],
          ),
        ),
      );

  Widget _buildTextField(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 90, minHeight: 36),
        child: TextFormField(
          controller: _chatController.messageController,
          focusNode: _focusNode,
          maxLines: 50,
          minLines: 1,
          keyboardType: TextInputType.multiline,
          onChanged: (value) {
            _chatController.chatBotCommand.message = value;
          },
          decoration: _getInputDecoration(context),
        ),
      );

  InputDecoration _getInputDecoration(BuildContext context) => InputDecoration(
        alignLabelWithHint: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceDim,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        suffixIcon: _buildSuffixIcon(),
        hintText: 'ask_anything'.tr,
        border: _buildInputBorder(context),
        focusedBorder: _buildInputBorder(context),
        enabledBorder: _buildInputBorder(context),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
      );

  Widget _buildSuffixIcon() => _chatController.messageController.text.isEmpty
      ? IconButton(
          onPressed: () {},
          icon: const Icon(Icons.mic),
        )
      : const Icon(Icons.close);

  OutlineInputBorder _buildInputBorder(BuildContext context) => OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(28)),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
      );

  Widget _buildSendButton(BuildContext context) => SizedBox(
        height: 40,
        width: 40,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 12,
          child: Center(
            child: SendButton(
              onPressed: () {
                if (_chatController.messageController.text.isNotEmpty) {
                  _chatController.sendMessage();
                }
              },
            ),
          ),
        ),
      );
}
