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
            onTap: () => authController.logout(),
          ),
        ],
      ),
    );
  }
}
