import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/views/common/wigets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chatify_ai/controllers/common_controller.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({super.key});
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
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildTileWigets(
                title: 'Remember me',
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.dataEncryption.value,
                  onClick: () => commonController.toggleDataEncryption(),
                ),
              ),
              BuildTileWigets(
                title: 'Biometric ID',
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.isDarkMode.value,
                  onClick: () => commonController.toggleDarkMode(),
                ),
              ),
              BuildTileWigets(
                title: 'Face ID',
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.enableForNewChats.value,
                  onClick: () => commonController.toggleEnableForNewChats(),
                ),
              ),
              BuildTileWigets(
                title: 'SMS Authenticator',
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.chatHistory.value,
                  onClick: () => commonController.toggleChatHistory(),
                ),
              ),
              BuildTileWigets(
                title: 'Google Authenticator',
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.dataTraining.value,
                  onClick: () => commonController.toggleDataTraining(),
                ),
              ),
              BuildTileWigets(
                title: 'Device Management',
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
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
        );
      }),
    );
  }
}
