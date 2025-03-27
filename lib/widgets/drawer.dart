import 'package:chatify_ai/controllers/auth_controller.dart';
import 'package:chatify_ai/controllers/dashboard_controller.dart';
import 'package:chatify_ai/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class DrawerWigets extends StatelessWidget {
  const DrawerWigets({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 120,
            child: DrawerHeader(
              decoration:
                  BoxDecoration(border: Border(bottom: BorderSide.none)),
              child: Obx(() {
                final user = authController.firebaseUser.value;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              user?.email ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface,
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
                            backgroundColor: Colors.white,
                            radius: 3,
                          ),
                        ),
                        Positioned(
                          top: -4,
                          left: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 1,
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 2,
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          left: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 2,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 1,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 1,
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
              dashboardController.changeIndex(2);
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
              dashboardController.changeIndex(0);
              Get.to(AppRoutes.imageView, preventDuplicates: false);
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
              dashboardController.changeIndex(1);
              Get.to(AppRoutes.audioView, preventDuplicates: false);
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
              dashboardController.changeIndex(3);

              Get.to(AppRoutes.history, preventDuplicates: false);
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
              dashboardController.changeIndex(4);
              Get.to(AppRoutes.setting, preventDuplicates: false);
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedLogout01, color: Colors.red),
            title: Text(
              'logout'.tr,
              style: TextStyle(fontSize: 15, color: Colors.red),
            ),
            onTap: () {
              authController.logout();
            },
          ),
        ],
      ),
    );
  }
}
