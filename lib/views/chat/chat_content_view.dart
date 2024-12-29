import 'package:chatify_ai/library/flutter_chat/lib/flutter_chat.dart';
import 'package:chatify_ai/library/flutter_chat/lib/src/types/types.dart' as types;
import 'package:chatify_ai/models/chatbot.model.dart';
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
  final TextEditingController _messageController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  final ScrollController _scrollController = ScrollController();
  String? chatRoomId;
  final user = FirebaseAuth.instance.currentUser;
  bool _isScrolledToBottom = true;

  ChatBot chatbot = Get.arguments as ChatBot;
  late types.User _user;
  List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _user = types.User(id: user!.uid, firstName: user?.displayName, role: types.Role.user);
    // Get.printInfo(info: chatbot.botName);
  }

  void _handleSendPressed(types.PartialText message, {String? remoteId}) {}

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
      body: Chat(messages: _messages, onSendPressed: _handleSendPressed, user: _user),
    );
  }
}
