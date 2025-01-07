class SpeechCommand {
  String? text; // The text to be converted to speech
  String? voice; // The voice ID to be used (alloy, echo, etc.)
  String? language; // The language for speech generation
  double? speed; // Speech rate (optional)
  String? format; // Audio format (optional)

  SpeechCommand(
      {this.text,
      this.voice = 'alloy',
      this.language = 'english',
      this.speed = 1.0,
      this.format = 'mp3'});

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'voice': voice,
      'language': language,
      'speed': speed,
      'format': format,
    };
  }

  // Create from JSON
  factory SpeechCommand.fromJson(Map<String, dynamic> json) {
    return SpeechCommand(
      text: json['text'],
      voice: json['voice'],
      language: json['language'],
      speed: json['speed'],
      format: json['format'],
    );
  }

  // Copy with method for immutable updates
  SpeechCommand copyWith({
    String? text,
    String? voice,
    String? language,
    double? speed,
    String? format,
  }) {
    return SpeechCommand(
      text: text ?? this.text,
      voice: voice ?? this.voice,
      language: language ?? this.language,
      speed: speed ?? this.speed,
      format: format ?? this.format,
    );
  }

  // Reset command to default values
  void reset() {
    text = null;
    voice = 'alloy';
    language = 'english';
    speed = 1.0;
    format = 'mp3';
  }

  // Validate command
  bool isValid() {
    return text != null &&
        text!.isNotEmpty &&
        voice != null &&
        language != null;
  }

  // Available voices
  static List<String> get availableVoices =>
      ['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer'];

  // Available languages
  static List<String> get availableLanguages => [
        'english',
        'spanish',
        'french',
        'german',
        'italian',
        'portuguese',
        'dutch'
      ];
}
