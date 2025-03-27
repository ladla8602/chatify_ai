import 'package:chatify_ai/models/subscription_plan.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/firebase_functions_service.dart';
import '../services/firestore_service.dart';

class PlanController extends GetxController {
  List<SubscriptionPlan> plans = <SubscriptionPlan>[].obs;

  final FirebaseFunctionsService _firebaseFunctionsService;

  PlanController({
    FirestoreService? firestoreService,
    FirebaseFunctionsService? firebaseFunctionsService,
  }) : _firebaseFunctionsService = firebaseFunctionsService ?? FirebaseFunctionsService();

  @override
  void onInit() {
    getPlans();
    super.onInit();
  }

  Future<void> getPlans() async {
    try {
      final subscriptionPlans = await _firebaseFunctionsService.getSubscriptionPlans();
      plans.assignAll(subscriptionPlans);
    } catch (e) {
      debugPrint('Error fetching plans: $e');
      // Handle error appropriately
    }
  }
}
