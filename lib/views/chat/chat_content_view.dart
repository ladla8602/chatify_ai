import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import '../../controllers/auth_controller.dart';
import '../../services/chat_service.dart';
import '../../services/open_ai_service.dart';
import '../../constants/constants.dart';

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
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  bool _isScrolledToBottom = true;

  @override
  void initState() {
    super.initState();
    _initializeChatRoom();
  }

  // Initialize chat room (either create a new one or fetch an existing one)
  Future<void> _initializeChatRoom() async {
    final chatRoomService = ChatService();
    String? roomId = await chatRoomService.createChatRoom();
    setState(() {
      chatRoomId = roomId;
    });
  }

  // Send message function
  void _sendMessage() async {
    if (_messageController.text.isNotEmpty && chatRoomId != null) {
      // Send the user's message to Firestore
      FirebaseFirestore.instance.collection('chats').doc(chatRoomId).collection('messages').add({
        'text': _messageController.text,
        'senderId': userId,
        'createdAt': Timestamp.now(),
      });

      // Get AI response and save it to Firestore
      String response = await OpenAIService().getAIResponse(_messageController.text);
      FirebaseFirestore.instance.collection('chats').doc(chatRoomId).collection('messages').add({
        'text': response,
        'senderId': 'openai',
        'createdAt': Timestamp.now(),
      });

      _messageController.clear();
      _scrollToBottom();
    }
  }

  // Scroll to the bottom when a new message is added
  void _scrollToBottom() {
    if (_isScrolledToBottom) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  // Handle scroll events to check if we're at the bottom
  void _onScroll() {
    if (_scrollController.position.atEdge) {
      setState(() {
        _isScrolledToBottom = _scrollController.position.pixels == _scrollController.position.maxScrollExtent;
      });
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('h:mm a');
    return formatter.format(dateTime);
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('createdAt', descending: false) // Order messages from oldest to newest
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('What can I help with?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUserMessage = message['senderId'] == userId;
                    final timestamp = message['createdAt'] as Timestamp;
                    final formattedTime = _formatTimestamp(timestamp);

                    return Align(
                      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isUserMessage ? ColorConstant.primaryColor : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['text'],
                              style: TextStyle(
                                color: isUserMessage ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                color: isUserMessage ? Colors.white70 : Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(fontSize: 14),
                        controller: _messageController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          prefixIcon: Icon(
                            Icons.add,
                            size: 20,
                          ),
                          suffixIcon: Icon(
                            Icons.mic,
                            size: 20,
                          ),
                          hintText: "Ask me anything...",
                          hintStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: CircleAvatar(
                        backgroundColor: ColorConstant.primaryColor,
                        child: Icon(
                          HugeIcons.strokeRoundedSent,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
