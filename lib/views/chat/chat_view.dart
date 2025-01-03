import 'package:chatify_ai/controllers/chatbot_controller.dart';
import 'package:chatify_ai/routes/app_routes.dart';
import 'package:chatify_ai/views/chat/widgets/chatbot_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
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
  ChatbotController controller = Get.find();
  List<Map<String, dynamic>> capabilities = [
    {
      "title": "Answer all your questions.",
      "subtitle": "(Just ask me anything you like!)",
    },
    {
      "title": "Generate all the text you want.",
      "subtitle": "(essays, articles, reports, stories, & more)",
    },
    {
      "title": "Conversational AI.",
      "subtitle": "(I can talk to you like a natural human)",
    }
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start off-screen to the left
      end: Offset.zero, // End at original position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              HugeIcons.strokeRoundedMenuSquare,
              color: Theme.of(context).iconTheme.color,
            ),
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
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    Column(
                      children: List.generate(
                        capabilities.length,
                        (index) {
                          return CapabilityCard(
                            title: capabilities[index]["title"],
                            subtitle: capabilities[index]["subtitle"],
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.chatContentView,
                                arguments: {"chatbot": controller.chatbots[0]},
                              );
                            },
                          );
                        },
                      ),
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
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.chatbots.isNotEmpty) {
                          Get.toNamed(AppRoutes.chatContentView, arguments: {"chatbot": controller.chatbots[0]});
                        } else {
                          Get.snackbar("Error", "No chatbots available");
                        }
                      },
                      child: Row(
                        children: [
                          Flexible(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 90, minHeight: 36),
                              child: TextFormField(
                                enabled: false,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.surfaceDim,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  hintText: '${'ask_anything'.tr}...',
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(28)),
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(28)),
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(28)),
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(28)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
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
            ),
          ),
        ],
      ),
    );
  }
}

class CapabilityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const CapabilityCard({super.key, required this.title, required this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(10), boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ]),
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
      ),
    );
  }
}
