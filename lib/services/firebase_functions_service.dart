import 'package:cloud_functions/cloud_functions.dart';

class FirebaseFunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<dynamic> generateAiResponse(String prompt) async {
    final response = await _functions.httpsCallable('generateResponse').call({'prompt': prompt});
    return response.data;
  }
}
