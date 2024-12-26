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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Custom Instructions',
          style: TextStyle(fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What would you like Chatify to know about you to provide better responses?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: firstAnswerController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Your answer ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'How would you like Chatify to respond?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: secondAnswerController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Your answer ...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Enable for new chats',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                  child: ElevatedButtonWigets(
                    text: 'Cancel',
                    backgroundColor: Colors.green.shade50,
                    foregroundColor: Colors.green,
                    onClick: () {
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButtonWigets(
                      text: 'Save',
                      backgroundColor: ColorConstant.primaryColor,
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
