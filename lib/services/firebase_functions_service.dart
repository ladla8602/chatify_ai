import 'package:cloud_functions/cloud_functions.dart';

class FirebaseFunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<dynamic> generateAiResponse(String prompt) async {
    final response = await _functions
        .httpsCallable('generateResponse')
        .call({'prompt': prompt});
    return response.data;
  }

  Future<String> callHelloWorld() async {
    try {
      final result = await _functions.httpsCallable('helloWorld').call();
      return result.data as String;
    } catch (e) {
      print('Error calling function: $e');
      rethrow;
    }
  }
}
