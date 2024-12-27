import 'package:chatify_ai/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../constants/constants.dart';
import '../../widgets/drawer.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _messageController = TextEditingController();
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
      body: Column(
        children: [
          SizedBox(height: 50),
          SvgPicture.asset(
            'assets/icons/chatify_logo.svg',
            height: 60,
            color: ColorConstant.primaryColor,
          ),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
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
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.chatContentView);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 14),
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
                      // Expanded(
                      //   child: TextFormField(
                      //     readOnly: false,
                      //     style: TextStyle(fontSize: 14),
                      //     controller: _messageController,
                      //     decoration: InputDecoration(
                      //       contentPadding: EdgeInsets.symmetric(
                      //           vertical: 12, horizontal: 8),
                      //       prefixIcon: Icon(
                      //         HugeIcons.strokeRoundedAdd01,
                      //         size: 20,
                      //       ),
                      //       suffixIcon: Icon(
                      //         HugeIcons.strokeRoundedMic01,
                      //         size: 20,
                      //       ),
                      //       hintText: "Ask me anything...",
                      //       hintStyle: TextStyle(fontSize: 13),
                      //       border: OutlineInputBorder(
                      //         borderSide: BorderSide.none,
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //       filled: true,
                      //       fillColor: Colors.grey.shade100,
                      //     ),
                      //   ),
                      // ),
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
        ],
      ),
    );
  }
}

class CapabilityCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const CapabilityCard(
      {super.key, required this.title, required this.subtitle});

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
