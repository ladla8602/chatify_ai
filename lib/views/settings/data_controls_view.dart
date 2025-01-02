import 'package:chatify_ai/controllers/common_controller.dart';
import 'package:chatify_ai/views/common/wigets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class DataControlsView extends StatelessWidget {
  const DataControlsView({super.key});

  @override
  Widget build(BuildContext context) {
    final CommonController commonController = Get.put(CommonController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'data_controls'.tr,
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              return BuildTileWigets(
                icon: HugeIcons.strokeRoundedWorkHistory,
                title: 'Chat History',
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.chatHistory.value,
                  onClick: () {
                    commonController.toggleChatHistory();
                  },
                ),
              );
            }),
            Obx(() {
              return BuildTileWigets(
                icon: HugeIcons.strokeRoundedAnalytics02,
                title: 'Data Training',
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.dataTraining.value,
                  onClick: () {
                    commonController.toggleDataTraining();
                  },
                ),
              );
            }),
            Obx(() {
              return BuildTileWigets(
                icon: HugeIcons.strokeRoundedKey02,
                title: 'Data Encryption',
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.dataEncryption.value,
                  onClick: () {
                    commonController.toggleDataEncryption();
                  },
                ),
              );
            }),
            BuildTileWigets(
              icon: HugeIcons.strokeRoundedArrowUpDown,
              title: 'Third-party Integrations',
              onTap: () {},
            ),
            BuildTileWigets(
              icon: HugeIcons.strokeRoundedFileExport,
              title: 'Export Data',
              onTap: () {},
            ),
            BuildTileWigets(
              icon: HugeIcons.strokeRoundedDelete02,
              title: 'Delete All Chat History',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
