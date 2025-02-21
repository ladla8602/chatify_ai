import 'package:chatify_ai/library/flutter_chat/lib/flutter_chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../controllers/chatbot_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/drawer.dart';
import 'widgets/chatbot_card_widget.dart';
import 'widgets/chat_bot_loading_effect.dart';
import 'package:flutter_svg/svg.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView>
    with SingleTickerProviderStateMixin {
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
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
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

  void _showChatifyAIBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: SelectModelWigets(),
        );
      },
    );
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
        title: GestureDetector(
          onTap: () => _showChatifyAIBottomSheet(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 52),
              Text(
                "Chatify AI",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(HugeIcons.strokeRoundedArrowDown01)
            ],
          ),
        ),
      ),
      drawer: DrawerWigets(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Obx(() {
                  if (controller.isLoading) {
                    return ChatBotLoadingEffect();
                  }
                  if (controller.error != null) {
                    return Center(child: Text(controller.error!));
                  }
                  return SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.chatbots.length,
                      itemBuilder: (_, i) =>
                          ChatbotCardWidget(chatbot: controller.chatbots[i]),
                      separatorBuilder: (context, id) =>
                          const SizedBox(width: 8),
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
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13),
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

class CapabilityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const CapabilityCard(
      {super.key, required this.title, required this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.25),
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

class SelectModelWigets extends StatefulWidget {
  const SelectModelWigets({super.key});

  @override
  State<SelectModelWigets> createState() => _SelectModelWigetsState();
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
                          color: index == selectedIndex
                              ? Colors.green
                              : Colors.black12,
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
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
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
                                          color: index == selectedIndex
                                              ? Colors.black
                                              : Colors.grey.shade700,
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
                                color: index == selectedIndex
                                    ? Colors.black
                                    : Colors.grey.shade700,
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
