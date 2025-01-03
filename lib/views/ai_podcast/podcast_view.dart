import 'package:chatify_ai/controllers/podcast_controller.dart';
import 'package:chatify_ai/library/flutter_chat/lib/flutter_chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../common/button_wigets.dart';

class PodcastResearchView extends StatelessWidget {
  const PodcastResearchView({super.key});
  @override
  Widget build(BuildContext context) {
    final PodcastController controller = Get.put(PodcastController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Podcast Researcher'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]),
            child: TextFormField(
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
              controller: controller.searchController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                hintText: 'Search AI podcasts...',
                suffixIcon: IconButton(
                  icon: const Icon(
                    HugeIcons.strokeRoundedSearch01,
                    size: 22,
                  ),
                  onPressed: () => controller
                      .searchPodcasts(controller.searchController.text),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none),
              ),
              onFieldSubmitted: controller.searchPodcasts,
            ),
          ),
          Obx(
            () => controller.isLoading.value
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: controller.podcasts.length,
                      itemBuilder: (context, index) {
                        final podcast = controller.podcasts[index];
                        return PodcastCard(
                          title: podcast['collectionName'] ?? 'Unknown',
                          author: podcast['artistName'] ?? 'Unknown',
                          imageUrl: podcast['artworkUrl100'] ?? '',
                          description: podcast['description'] ??
                              'No description available',
                          podcastData: podcast,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class PodcastCard extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final String description;
  final Map<String, dynamic> podcastData;

  const PodcastCard({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.description,
    required this.podcastData,
  });

  @override
  Widget build(BuildContext context) {
    final PodcastController controller = Get.find();
    return InkWell(
      onTap: () => controller.setSelectedPodcast(podcastData),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      author,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
