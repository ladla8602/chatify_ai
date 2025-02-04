import 'dart:developer';

import 'package:get/get.dart';

import '../services/firebase_functions_service.dart';
import '../services/firestore_service.dart';

class SubscriptionController extends GetxController {
  // Dependencies
  final FirestoreService _firestoreService;
  final FirebaseFunctionsService _firebaseFunctionsService;

  SubscriptionController({
    FirestoreService? firestoreService,
    FirebaseFunctionsService? firebaseFunctionsService,
  })  : _firestoreService = firestoreService ?? FirestoreService(),
        _firebaseFunctionsService = firebaseFunctionsService ?? FirebaseFunctionsService();

  Future<String> createSubscription(String planId) async {
    try {
      final response = await _firebaseFunctionsService.createSubscription(planId);
      return response;
    } catch (e) {
      log('Error processing bot response: $e');
      rethrow;
    }
  }
}
