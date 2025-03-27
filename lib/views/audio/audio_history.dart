import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AudioHistory extends StatelessWidget {
  const AudioHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(HugeIcons.strokeRoundedClock04),
                SizedBox(width: 10),
                Text(
                  "Audio History",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: 10),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey.shade200,
                                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.5), width: 1.5)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                  'https://img.freepik.com/premium-vector/vector-young-man-anime-style-character-vector-illustration-design-manga-anime-boy_147933-12445.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid'),
                            ),
                          ),
                          Positioned(
                              right: 2,
                              bottom: 2,
                              child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  child: Icon(
                                    HugeIcons.strokeRoundedDownloadCircle01,
                                    color: Colors.white,
                                  )))
                        ],
                      ),
                      SizedBox(height: 10),
                      Text('2024-12-29 10:00 AM', style: TextStyle(fontSize: 11)),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
