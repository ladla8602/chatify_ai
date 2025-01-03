import 'package:chatify_ai/controllers/podcast_controller.dart';
import 'package:chatify_ai/views/common/button_wigets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PodcastDetailsView extends StatelessWidget {
  const PodcastDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final PodcastController controller = Get.find<PodcastController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podcast Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          controller.selectedPodcast.value['artworkUrl600'] ??
                              controller
                                  .selectedPodcast.value['artworkUrl100'] ??
                              '',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 200,
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error, size: 50),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.selectedPodcast.value['collectionName'] ??
                            'Unknown',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.selectedPodcast.value['artistName'] ??
                            'Unknown Artist',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailSection(
                        'Genre',
                        controller.selectedPodcast.value['primaryGenreName'] ??
                            'Unknown',
                      ),
                      _buildDetailSection(
                        'Country',
                        controller.selectedPodcast.value['country'] ??
                            'Unknown',
                      ),
                      _buildDetailSection(
                        'Episodes',
                        '${controller.selectedPodcast.value['trackCount'] ?? 'Unknown'} episodes',
                      ),
                      _buildDetailSection(
                        'Release Date',
                        controller.selectedPodcast.value['releaseDate'] != null
                            ? DateTime.parse(controller
                                    .selectedPodcast.value['releaseDate'])
                                .toString()
                                .split(' ')[0]
                            : 'Unknown',
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.selectedPodcast.value['description'] ??
                            'No description available',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildDetailSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
