import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/views/common/button_wigets.dart';
import 'package:chatify_ai/views/common/wigets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hugeicons/hugeicons.dart';
import '../common/wigets.dart';
import 'package:chatify_ai/controllers/common_controller.dart';

class Security extends StatelessWidget {
  const Security({super.key});

  get commonController => null;

  @override
  Widget build(BuildContext context) {
    final CommonController commonController = Get.put(CommonController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Security',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Obx(
              () {
                return BuildTileWigets(
                  title: ' Biometric ID',
                  trailing: CustomSwitchButtonWigets(
                    isSwitched: commonController.isDarkMode.value,
                    onClick: () => commonController.toggleDarkMode(),
                  ),
                );
              },
            ),
            Obx(
              () {
                return BuildTileWigets(
                  title: ' Face ID',
                  trailing: CustomSwitchButtonWigets(
                    isSwitched: commonController.isDarkMode.value,
                    onClick: () => commonController.toggleEnableForNewChats(),
                  ),
                );
              },
            ),
            Obx(
              () {
                return BuildTileWigets(
                  title: ' SMS Authenticator',
                  trailing: CustomSwitchButtonWigets(
                    isSwitched: commonController.isDarkMode.value,
                    onClick: () => commonController.toggleChatHistory(),
                  ),
                );
              },
            ),
            Obx(
              () {
                return BuildTileWigets(
                  title: ' Google Authenticator',
                  trailing: CustomSwitchButtonWigets(
                    isSwitched: commonController.isDarkMode.value,
                    onClick: () => commonController.toggleDataTraining(),
                  ),
                );
              },
            ),
            BuildTileWigets(
              title: 'Device Management',
            ),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 48,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.green,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Change Password',
                    style: TextStyle(color: Colors.green),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
