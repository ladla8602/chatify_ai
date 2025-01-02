class ImageGenCommand {
  String? art;
  String? lighting;
  String? mood;
  String? prompt;
  String? model;
  String? size;
  String? style;

  ImageGenCommand({this.art, this.lighting, this.mood, this.prompt, this.model, this.size, this.style});

  ImageGenCommand.fromJson(Map<String, dynamic> json) {
    art = json['art'];
    lighting = json['lighting'];
    mood = json['mood'];
    prompt = json['prompt'];
    model = json['model'];
    size = json['size'];
    style = json['style'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['art'] = art;
    data['lighting'] = lighting;
    data['mood'] = mood;
    data['prompt'] = prompt;
    data['model'] = model;
    data['size'] = size;
    data['style'] = style;
    return data;
  }
}
