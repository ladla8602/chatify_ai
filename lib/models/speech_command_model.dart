class SpeechCommand {
  String? text;
  String? voice;
  String? model;
  String? format;

  SpeechCommand({this.text, this.voice, this.model, this.format});

  SpeechCommand.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    voice = json['voice'];
    model = json['model'];
    format = json['format'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['text'] = text;
    data['voice'] = voice;
    data['model'] = model;
    data['format'] = format;
    return data;
  }
}
