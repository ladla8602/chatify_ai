class ChatBotCommand {
  String? chatRoomId;
  String? chatBotId;
  String? chatBotName;
  bool? roomExist;
  String? title;
  String? message;
  String? prompt;
  String? model;
  String? action;
  String? rewardToken;
  Vision? vision;

  ChatBotCommand({
    this.chatRoomId,
    this.chatBotId,
    this.chatBotName,
    this.roomExist,
    this.title = "New Conversation",
    this.message,
    this.prompt,
    this.model = "gpt-3.5-turbo-1106",
    this.action = "next",
    this.rewardToken,
    this.vision,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['chatRoomId'] = chatRoomId;
    data['chatBotId'] = chatBotId;
    data['chatBotName'] = chatBotName;
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
