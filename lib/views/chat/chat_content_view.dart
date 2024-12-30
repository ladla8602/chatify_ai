import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/controllers/chat_controller.dart';
import 'package:chatify_ai/library/flutter_chat/lib/flutter_chat.dart';
import 'package:chatify_ai/library/flutter_chat/lib/src/types/types.dart' as types;
import 'package:chatify_ai/models/chatbot.model.dart';
import 'package:chatify_ai/widgets/not_found_widget.dart';
import 'package:chatify_ai/widgets/typing_loader.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../controllers/auth_controller.dart';
import '../../services/open_ai_service.dart';

import '../../widgets/drawer.dart';

class ChatContentView extends StatefulWidget {
  const ChatContentView({super.key});

  @override
  State<ChatContentView> createState() => _ChatContentViewState();
}

class _ChatContentViewState extends State<ChatContentView> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  final ScrollController _scrollController = ScrollController();
  String? chatRoomId;
  final user = FirebaseAuth.instance.currentUser;
  bool _isScrolledToBottom = true;

  ChatBot chatbot = Get.arguments as ChatBot;
  late types.User _user;
  ChatController chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    _user = types.User(id: user!.uid, firstName: user?.displayName, role: types.Role.user);
    // Get.printInfo(info: chatbot.botName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(HugeIcons.strokeRoundedMenuSquare, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text(
          "app_name".tr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: DrawerWigets(),
      body: Chat(
        messages: chatController.messages,
        onSendPressed: chatController.handleSendPressed,
        user: _user,
        showUserAvatars: false,
        showUserNames: true,
        usePreviewData: false,
        emptyState: chatController.isDataLoadingForFirstTime.value
            ? const Center(child: TypingLoaderWidget())
            : NotFoundWidget(
                title: 'no_chat'.tr,
                onButtonClick: () => Navigator.of(context).pop(),
              ),
        customBottomWidget: Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 90, minHeight: 24),
                      child: SizedBox(
                        height: kTextTabBarHeight - 6,
                        child: TextFormField(
                          controller: _messageController,
                          focusNode: _focusNode,
                          maxLines: 50,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          onChanged: (v) {},
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            contentPadding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                            suffixIcon: InkWell(
                              onTap: () {},
                              child: _messageController.text.isEmpty
                                  ? IconButton(
                                      onPressed: () async {},
                                      icon: const Icon(Icons.scanner),
                                    )
                                  : const Icon(Icons.close),
                            ),
                            hintText: 'enter_your_message'.tr,
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(28)),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(28)),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(28)),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(28)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 12,
                      child: Center(
                        child: SendButton(
                          onPressed: () {
                            if (_messageController.text.isNotEmpty) {
                              chatController.sendMessage();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
