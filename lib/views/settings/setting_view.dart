import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/controllers/auth_controller.dart';
import 'package:chatify_ai/controllers/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../routes/app_routes.dart';
import '../common/wigets.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final CommonController commonController = Get.put(CommonController());
    final AuthController authController = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedBubbleChat,
            title: 'Custom Instructions',
            onTap: () {
              Get.toNamed(AppRoutes.customInstruction);
            },
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedFilterHorizontal,
            title: 'Data Controls',
            onTap: () {
              Get.toNamed(AppRoutes.dataControls);
            },
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedCreditCard,
            title: 'Payment Methods',
            onTap: () {
              Get.toNamed(AppRoutes.paymentMethods);
            },
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedLink01,
            title: 'Linked Accounts',
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: (8.0),
            ),
            child: Row(
              children: [
                Text(
                  'General',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                SizedBox(width: 10),
                Expanded(child: Divider(color: Colors.grey.shade200)),
              ],
            ),
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedUser,
            title: 'Personal Info',
            onTap: () {},
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedSecurity,
            title: 'Security',
            onTap: () {},
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedGlobe02,
            title: 'Language',
            trailing: const Text(
              'English (US)',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Get.toNamed(AppRoutes.languaeview);
            },
          ),
          Obx(
            () {
              return BuildTileWigets(
                icon: HugeIcons.strokeRoundedDarkMode,
                title: 'Dark Mode',
                trailing: CustomSwitchButtonWigets(
                  isSwitched: commonController.isDarkMode.value,
                  onClick: () => commonController.toggleDarkMode(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: (8.0),
            ),
            child: Row(
              children: [
                Text(
                  'About',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                SizedBox(width: 10),
                Expanded(child: Divider(color: Colors.grey.shade200)),
              ],
            ),
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedHelpCircle,
            title: 'Help Center',
            onTap: () {},
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedTask01,
            title: 'Terms of Use',
            onTap: () {},
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedSquareLock01,
            title: 'Privacy Policy',
            onTap: () {},
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedInformationCircle,
            title: 'About Chatify',
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading:
                const Icon(HugeIcons.strokeRoundedLogout01, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            // onTap: () => authController.logout(),
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.white,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 28,
                          height: 2,
                          decoration:
                              BoxDecoration(color: Colors.grey.shade400),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Logout',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        const SizedBox(height: 16),
                        Divider(
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        const Text('Are you sure you want to logout?'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  height: 44,
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: ColorConstant.primaryColor
                                        .withOpacity(0.2),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: ColorConstant.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  authController.logout();
                                },
                                child: Container(
                                  height: 44,
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: ColorConstant.primaryColor,
                                  ),
                                  child: const Text(
                                    'Yes,Logout',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
