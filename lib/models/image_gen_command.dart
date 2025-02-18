class ImageGenCommand {
  String? art;
  String? prompt;
  String? model;
  String? size;
  String? style;
  String? quality;

  ImageGenCommand({this.art, this.prompt, this.model, this.size, this.style, this.quality});

  ImageGenCommand.fromJson(Map<String, dynamic> json) {
    art = json['art'];
    prompt = json['prompt'];
    model = json['model'];
    size = json['size'];
    style = json['style'];
    quality = json['quality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['art'] = art;
    data['prompt'] = prompt;
    data['model'] = model;
    data['size'] = size;
    data['style'] = style;
    data['quality'] = quality;
    return data;
  }
}
