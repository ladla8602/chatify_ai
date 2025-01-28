import 'package:chatify_ai/routes/app_routes.dart';
import 'package:chatify_ai/views/common/button_wigets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class SuccessfullyScreen extends StatefulWidget {
  const SuccessfullyScreen({super.key});

  @override
  State<SuccessfullyScreen> createState() => _SuccessfullyScreenState();
}

class _SuccessfullyScreenState extends State<SuccessfullyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Row(
              children: [
                Icon(
                  HugeIcons.strokeRoundedMultiplicationSign,
                  size: 24,
                  color: Colors.black,
                ),
              ],
            ),
            Spacer(),
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(
                    HugeIcons.strokeRoundedStar,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const Positioned(
                  top: -8,
                  left: -8,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 6,
                  ),
                ),
                const Positioned(
                  top: -8,
                  right: -8,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 6,
                  ),
                ),
                const Positioned(
                  bottom: -8,
                  left: -15,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 3,
                  ),
                ),
                const Positioned(
                  bottom: -8,
                  right: -18,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 2,
                  ),
                ),
                const Positioned(
                  bottom: -8,
                  right: 0,
                  left: 19,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 2,
                  ),
                ),
                const Positioned(
                  left: -4,
                  top: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 2,
                  ),
                ),
                const Positioned(
                  right: -4,
                  top: 18,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Congratulations!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 15),
            Text(
              'You have successfully subscribed to the Basic plan!'.tr,
              style: const TextStyle(
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 10),
            Text(
              'Benefits Unlocked:',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        HugeIcons.strokeRoundedTick02,
                        size: 20,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Access to all features'.tr,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 15),
            Text(
              'Enjoy the enhanced Chatify experience and make the most of your subscription.'
                  .tr,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              'Thank you for choosing Chatify!'.tr,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButtonWigets(
              text: 'Ok',
              onClick: () {
                Get.toNamed(AppRoutes.reviewSummary);
              },
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
