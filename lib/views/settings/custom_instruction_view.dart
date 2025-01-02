import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/controllers/common_controller.dart';
import 'package:chatify_ai/views/common/button_wigets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../common/wigets.dart';

class CustomInstructionView extends StatelessWidget {
  const CustomInstructionView({super.key});

  @override
  Widget build(BuildContext context) {
    final CommonController commonController = Get.put(CommonController());
    final TextEditingController firstAnswerController = TextEditingController();
    final TextEditingController secondAnswerController =
        TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'custom_instruction'.tr,
          style: TextStyle(fontSize: 20),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What would you like Chatify to know about you to provide better responses?',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 8),
            TextFormField(
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              controller: firstAnswerController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Your answer ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'How would you like Chatify to respond?',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 8),
            TextFormField(
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              controller: secondAnswerController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Your answer ...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Enable for new chats',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Obx(
                  () {
                    return CustomSwitchButtonWigets(
                      isSwitched: commonController.enableForNewChats.value,
                      onClick: () => commonController.toggleEnableForNewChats(),
                    );
                  },
                )
              ],
            ),
            const Spacer(),
            Divider(color: Colors.grey.shade200),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 48,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButtonWigets(
                      text: 'Save',
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      onClick: () {}),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
