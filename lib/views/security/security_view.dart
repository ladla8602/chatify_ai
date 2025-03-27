import 'package:chatify_ai/controllers/common_controller.dart';
import 'package:chatify_ai/views/common/wigets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({super.key});
  @override
  Widget build(BuildContext context) {
    final CommonController commonController = Get.put(CommonController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'security'.tr,
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildTileWigets(
                title: 'remember'.tr,
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.dataEncryption.value,
                  onClick: () => commonController.toggleDataEncryption(),
                ),
              ),
              BuildTileWigets(
                title: 'biometric'.tr,
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.isDarkMode.value,
                  onClick: () => commonController.toggleDarkMode(),
                ),
              ),
              BuildTileWigets(
                title: 'face'.tr,
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.enableForNewChats.value,
                  onClick: () => commonController.toggleEnableForNewChats(),
                ),
              ),
              BuildTileWigets(
                title: 'sms_auth'.tr,
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.chatHistory.value,
                  onClick: () => commonController.toggleChatHistory(),
                ),
              ),
              BuildTileWigets(
                title: 'google_auth'.tr,
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.dataTraining.value,
                  onClick: () => commonController.toggleDataTraining(),
                ),
              ),
              BuildTileWigets(
                title: 'device_auth'.tr,
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'change_password'.tr,
                    )),
              )
            ],
          ),
        );
      }),
    );
  }
}
