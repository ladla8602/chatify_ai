import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify_ai/controllers/chat_controller.dart';
import 'package:chatify_ai/library/flutter_chat/lib/flutter_chat.dart';
import 'package:chatify_ai/library/flutter_chat/lib/src/types/types.dart' as types;
import 'package:chatify_ai/models/chatbot.model.dart';
import 'package:chatify_ai/widgets/not_found_widget.dart';
import 'package:chatify_ai/widgets/typing_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:uuid/uuid.dart';

class ChatContentView extends StatefulWidget {
  const ChatContentView({super.key});

  @override
  State<ChatContentView> createState() => _ChatContentViewState();
}

class SelectModelWigets extends StatefulWidget {
  const SelectModelWigets({super.key});

  @override
  State<SelectModelWigets> createState() => _SelectModelWigetsState();
}

class _ChatContentViewState extends State<ChatContentView> {
  final _focusNode = FocusNode();
  late ChatController _chatController;
  late final User? _currentUser;

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(context),
        body: _buildChatBody(context),
      );

  @override
  void dispose() {
    _focusNode.dispose();
    _chatController.clearChatContext();
    // Get.delete<ChatController>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _chatController = Get.put(ChatController());
    _initializeChat();
  }

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
            SizedBox(width: 2),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(height: MediaQuery.of(context).size.height * 0.4, child: SelectModelWigets());
                  },
                );
              },
              child: Icon(HugeIcons.strokeRoundedArrowDown01),
            )
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
        theme: Theme.of(context).brightness == Brightness.dark
            ? DarkChatTheme(
                primaryColor: Theme.of(context).colorScheme.surface,
                secondaryColor: Theme.of(context).colorScheme.surface,
              )
            : const DefaultChatTheme(),
      ));

  Widget _buildEmptyState() => Obx(() => _chatController.isDataLoadingForFirstTime.value
      ? const Center(child: TypingLoaderWidget())
      : NotFoundWidget(
          title: 'no_chat'.tr,
          onButtonClick: () => Navigator.of(context).pop(),
        ));

  OutlineInputBorder _buildInputBorder(BuildContext context) => OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(28)),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
      );

  Widget _buildMessageInput(BuildContext context) => SizedBox(
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

  Widget _buildSendButton(BuildContext context) => SizedBox(
        height: 40,
        width: 40,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 12,
          child: Center(
            child: SendButton(
              icon: HugeIcons.strokeRoundedSent,
              onPressed: () {
                if (_chatController.messageController.text.isNotEmpty) {
                  _chatController.sendMessage();
                }
              },
            ),
          ),
        ),
      );

  Widget _buildSuffixIcon() => _chatController.messageController.text.isEmpty
      ? IconButton(
          onPressed: () => _chatController.messageController.clear(),
          icon: const Icon(Icons.mic),
        )
      : const Icon(Icons.close);

  Widget _buildTextField(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 90, minHeight: 36),
        child: TextFormField(
          controller: _chatController.messageController,
          focusNode: _focusNode,
          maxLines: 50,
          minLines: 1,
          keyboardType: TextInputType.multiline,
          cursorHeight: 20,
          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          onChanged: (value) {
            _chatController.chatBotCommand.message = value;
            setState(() {});
          },
          decoration: _getInputDecoration(context),
        ),
      );

  InputDecoration _getInputDecoration(BuildContext context) => InputDecoration(
        alignLabelWithHint: true,
        // floatingLabelBehavior: FloatingLabelBehavior.never,
        // filled: true,
        // fillColor: Theme.of(context).colorScheme.surface,
        // labelStyle: TextStyle(color: Colors.red),
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

  void _initializeChat() {
    _currentUser = FirebaseAuth.instance.currentUser;
    final ChatBot chatbot = Get.arguments['chatbot'];

    _chatController
      ..chatbot = chatbot
      ..chatBotCommand.chatbot = chatbot
      ..chatBotCommand.provider = 'openai'
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
}

class _SelectModelWigetsState extends State<SelectModelWigets> {
  int selectedIndex = 0;

  List<Map<String, dynamic>> models = [
    {"name": "OpenAI", "icon": 'assets/icons/chatgpt.svg'},
    {"name": "Gemini", "icon": "assets/icons/gemini.svg"},
    {"name": "Deepseek", "icon": "assets/icons/deepseek.svg"},
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Select Model",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: models.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Card(
                    color: Colors.grey.shade100,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: index == selectedIndex ? Colors.green : Colors.black12,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 16,
                          child: SvgPicture.asset(
                            models[index]['icon'],
                            height: 40,
                          ),
                        ),
                        title: Text(
                          models[index]["name"],
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black38),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        models[index]['icon'],
                                        height: 12,
                                        width: 15,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        models[index]["name"],
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: index == selectedIndex ? Colors.black : Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                HugeIcons.strokeRoundedInformationCircle,
                                size: 18,
                                color: index == selectedIndex ? Colors.black : Colors.grey.shade700,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
