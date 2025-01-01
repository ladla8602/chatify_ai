import 'package:chatify_ai/views/chat/chat_content_view.dart';
import 'package:chatify_ai/views/chat/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/drawer.dart';
import 'audio/audio_view.dart';
import 'history/history_view.dart';
import 'image/image_generate_view.dart';
import 'settings/setting_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    final List<Widget> pages = [
      const ImageGenerateView(),
      const AudioGenerateView(),
      const ChatView(),
      const HistoryView(),
      const SettingView(),
    ];
    return Scaffold(
      body: Obx(
        () => pages[controller.selectedIndex],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedImage01),
              label: 'Image',
            ),
            BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedMic01),
              label: 'Audio',
            ),
            BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedMessage02),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedClock04),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(HugeIcons.strokeRoundedSettings02),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
