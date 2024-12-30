import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify_ai/models/chatbot.model.dart';
import 'package:chatify_ai/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatbotCardWidget extends StatelessWidget {
  final ChatBot chatbot;
  const ChatbotCardWidget({super.key, required this.chatbot});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.chatContentView, arguments: {"chatbot": chatbot}),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: CachedNetworkImage(
                      imageUrl: chatbot.botAvatar ?? "http://via.placeholder.com/200x150",
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 28,
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
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: const CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.green,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 48,
                child: Column(
                  children: [
                    SizedBox(
                      width: 70,
                      child: Text(
                        chatbot.botName.toString(),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      width: 80,
                      child: Text(
                        "(${chatbot.botRole.toString()})",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
