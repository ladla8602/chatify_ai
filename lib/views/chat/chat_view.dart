import 'package:chatify_ai/controllers/chat_controller.dart';
import 'package:chatify_ai/routes/app_routes.dart';
import 'package:chatify_ai/views/chat/widgets/chatbot_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../constants/constants.dart';
import '../../widgets/drawer.dart';
import 'widgets/chat_bot_loading_effect.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  TextEditingController _messageController = TextEditingController();
  ChatController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Start off-screen to the left
      end: Offset.zero, // End at original position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _animationController.forward();
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: DrawerWigets(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Obx(() {
                  // Show loading
                  if (controller.isLoading) {
                    return ChatBotLoadingEffect();
                  }

                  // Show error if any
                  if (controller.error != null) {
                    return Center(child: Text(controller.error!));
                  }

                  // Show list
                  return SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.chatbots.length,
                      itemBuilder: (_, i) => ChatbotCardWidget(chatbot: controller.chatbots[i]),
                      separatorBuilder: (context, id) => const SizedBox(width: 8),
                    ),
                  );
                }),
                SizedBox(height: 10),
                Text(
                  "Capabilities",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.primaryColor,
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    CapabilityCard(
                      title: "Answer all your questions.",
                      subtitle: "(Just ask me anything you like!)",
                    ),
                    CapabilityCard(
                      title: "Generate all the text you want.",
                      subtitle: "(essays, articles, reports, stories, & more)",
                    ),
                    CapabilityCard(
                      title: "Conversational AI.",
                      subtitle: "(I can talk to you like a natural human)",
                    ),
                    SizedBox(height: 30),
                    Text(
                      "These are just a few examples of what I can do.",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (controller.chatbots.isNotEmpty) {
                            Get.toNamed(AppRoutes.chatContentView, arguments: controller.chatbots[0]);
                          } else {
                            Get.snackbar("Error", "No chatbots available");
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      HugeIcons.strokeRoundedAdd01,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Ask me anything...',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Spacer(),
                                    Icon(
                                      HugeIcons.strokeRoundedMic01,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              backgroundColor: ColorConstant.primaryColor,
                              child: Icon(
                                HugeIcons.strokeRoundedSent,
                                color: Colors.white,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class CapabilityCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const CapabilityCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
