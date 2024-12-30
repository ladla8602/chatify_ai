import 'package:chatify_ai/controllers/auth_controller.dart';
import 'package:chatify_ai/routes/app_routes.dart';
import 'package:chatify_ai/views/history/history_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons/hugeicons.dart';

import '../constants/constants.dart';

class DrawerWigets extends StatelessWidget {
  const DrawerWigets({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 110,
            child: DrawerHeader(
              decoration: BoxDecoration(),
              child: Obx(() {
                final user = authController.firebaseUser.value;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        user?.photoURL ??
                            'https://cdn-icons-png.flaticon.com/128/8984/8984545.png',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.displayName ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user?.email ?? '',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.upgrade);
            },
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                        Positioned(
                          top: -6,
                          left: 0,
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: -4,
                          left: 10,
                          child: CircleAvatar(
                            radius: 1,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: 0,
                          child: CircleAvatar(
                            radius: 2,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          left: 0,
                          child: CircleAvatar(
                            radius: 2,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 10,
                          child: CircleAvatar(
                            radius: 1,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 1,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'upgrade_to_pro'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'enjoy_all_benefits'.tr,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      HugeIcons.strokeRoundedArrowRight01,
                      color: Colors.white,
                      size: 18,
                    )
                  ],
                )),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedAdd01, size: 18),
            title: Text(
              'new_chat'.tr,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedImage01, size: 18),
            title: Text(
              'image_generate'.tr,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              // Handle item tap
              Get.toNamed(AppRoutes.imageView);
            },
          ),
          ListTile(
            leading: Icon(
              HugeIcons.strokeRoundedMic01,
              size: 18,
            ),
            title: Text(
              'audio_generate'.tr,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              // Handle item tap
              Get.toNamed(AppRoutes.audioView);
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedClock04, size: 18),
            title: Text(
              'history'.tr,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              // Handle item tap
              Get.toNamed(AppRoutes.history);
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedSettings02, size: 18),
            title: Text(
              'settings'.tr,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              Get.toNamed(AppRoutes.setting);
            },
          ),
        ],
      ),
    );
  }
}
