// podcast_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../views/ai_podcast/podcat_details.dart';

class PodcastController extends GetxController {
  final RxList<dynamic> podcasts = <dynamic>[].obs;
  final RxBool isLoading = false.obs;
  final searchController = TextEditingController();
  final Rx<Map<String, dynamic>> selectedPodcast = Rx<Map<String, dynamic>>({});
  void setSelectedPodcast(Map<String, dynamic> podcast) {
    selectedPodcast.value = podcast;
    Get.to(() => const PodcastDetailsView());
  }

  Future<void> searchPodcasts(String query) async {
    if (query.isEmpty) return;

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(
          'https://itunes.apple.com/search?term=${Uri.encodeComponent(query)}&media=podcast',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        podcasts.value = data['results'];
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
