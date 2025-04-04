import 'chatbot.model.dart';

class ChatBotCommand {
  String? chatRoomId;
  String? chatBotId;
  ChatBot? chatbot;
  String? chatBotName;
  String? chatBotAvatar;
  bool? roomExist;
  String? title;
  String? message;
  String? prompt;
  String? provider;
  String? model;
  String? action;
  String? rewardToken;
  Vision? vision;

  ChatBotCommand({
    this.chatRoomId,
    this.chatBotId,
    this.chatbot,
    this.chatBotName,
    this.chatBotAvatar,
    this.roomExist,
    this.title = "New Conversation",
    this.message,
    this.prompt,
    this.provider = 'openai',
    this.model = "gpt-4o-mini",
    this.action = "next",
    this.rewardToken,
    this.vision,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['chatRoomId'] = chatRoomId;
    data['chatBotId'] = chatBotId;
    data['chatBotName'] = chatBotName;
    data['chatBotAvatar'] = chatBotAvatar;
    data['roomExist'] = roomExist ?? false;
    data['title'] = title;
    data['message'] = message;
    data['prompt'] = prompt;
    data['model'] = model;
    data['action'] = action;
    data['rewardToken'] = rewardToken;
    if (vision != null) {
      data['vision'] = vision!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toPayload() {
    final Map<String, dynamic> data = {};
    data['chatRoomId'] = chatRoomId;
    data['chatBot'] = chatbot?.toJson();
    data['message'] = message;
    data['provider'] = provider;
    return data;
  }
}

class Vision {
  String? mimeType;
  String? size;
  String? uri;
  String? text;
  String? fileName;

  Vision({this.mimeType, this.size, this.uri, this.text, this.fileName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['mimeType'] = mimeType;
    data['size'] = size;
    data['uri'] = uri;
    data['text'] = text;
    data['fileName'] = fileName;
    return data;
  }
}
