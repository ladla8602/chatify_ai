import 'package:chatify_ai/views/chat/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/floating_draggable_widget.dart';
import 'audio/audio_view.dart';
import 'history/history_view.dart';
import 'image/image_generate_view.dart';
import 'settings/setting_view.dart';
import 'voice_assistant/voice_assistant_screeen.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final List<Widget> pages = [
      const ImageGenerateView(),
      const AudioGenerateView(),
      const ChatView(),
      const HistoryView(),
      const SettingView(),
    ];
    return FloatingDraggableWidget(
      mainScreenWidget: Scaffold(
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
                label: 'image'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(HugeIcons.strokeRoundedMic01),
                label: 'audio'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(HugeIcons.strokeRoundedMessage02),
                label: 'chat'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(HugeIcons.strokeRoundedClock04),
                label: 'history'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(HugeIcons.strokeRoundedSettings02),
                label: 'settings'.tr,
              ),
            ],
          ),
        ),
      ),
      floatingWidget: FloatingActionButton(
        onPressed: () {
          // showModalBottomSheet(
          //   useSafeArea: true,
          //   isScrollControlled: true,
          //   useRootNavigator: true,
          //   backgroundColor: Theme.of(context).colorScheme.surface,
          //   context: context,
          //   builder: (context) {
          //     return const VoiceAssistantChatScreen();
          //   },
          // );
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VoiceAssistantChatScreen()));
        },
        tooltip: 'Voice Chat',
        shape: CircleBorder(),
        child: const Icon(HugeIcons.strokeRoundedMic01),
      ),
      floatingWidgetHeight: 60,
      floatingWidgetWidth: 60,
      dx: width * 0.8,
      dy: height * 0.78,
    );
  }
}
