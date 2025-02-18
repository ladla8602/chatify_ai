import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey =
      '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';
  Future<String> getAIResponse(String userMessage) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    final body = jsonEncode({
      'model': 'gpt-4',
      'messages': [
        {'role': 'system', 'content': 'You are a helpful assistant.'},
        {'role': 'user', 'content': userMessage}
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to fetch AI response');
    }
  }
}
