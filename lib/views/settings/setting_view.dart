import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/controllers/auth_controller.dart';
import 'package:chatify_ai/controllers/common_controller.dart';
import 'package:chatify_ai/controllers/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../controllers/theme_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/drawer.dart';
import '../common/wigets.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final CommonController commonController = Get.put(CommonController());
    final AuthController authController = Get.find<AuthController>();
    final ThemeController themeController = Get.put(ThemeController());
    final LanguageController languageController =
        Get.find<LanguageController>();
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(
              HugeIcons.strokeRoundedMenuSquare,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Text(
          'settings'.tr,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      drawer: DrawerWigets(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedBubbleChat,
            title: 'custom_instruction'.tr,
            onTap: () {
              Get.toNamed(AppRoutes.customInstruction);
            },
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedFilterHorizontal,
            title: 'data_controls'.tr,
            onTap: () {
              Get.toNamed(AppRoutes.dataControls);
            },
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedCreditCard,
            title: 'payment_methods'.tr,
            onTap: () {
              Get.toNamed(AppRoutes.paymentMethods);
            },
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedLink01,
            title: 'linked_accounts'.tr,
            onTap: () {
              Get.toNamed(AppRoutes.linkedAccount);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: (8.0),
            ),
            child: Row(
              children: [
                Text(
                  'general'.tr,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                SizedBox(width: 10),
                Expanded(child: Divider(color: Colors.grey.shade200)),
              ],
            ),
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedUser,
            title: 'personal_info'.tr,
            onTap: () {
              Get.toNamed(AppRoutes.personalInfo);
            },
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedSecurity,
            title: 'security'.tr,
            onTap: () {
              Get.toNamed(AppRoutes.security);
            },
          ),
          Obx(
            () => BuildTileWigets(
              icon: HugeIcons.strokeRoundedGlobe02,
              title: 'language'.tr,
              trailing: Text(
                languageController.selectedLanguage.value,
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Get.toNamed(AppRoutes.languaeview);
              },
            ),
          ),
          Obx(
            () {
              return BuildTileWigets(
                icon: HugeIcons.strokeRoundedDarkMode,
                title: 'dark_mode'.tr,
                trailing: CustomSwitchButtonWigets(
                  isSwitched: themeController.themeMode.value == ThemeMode.dark,
                  onClick: () => themeController.toggleTheme(),
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
                  'about'.tr,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                SizedBox(width: 10),
                Expanded(child: Divider(color: Colors.grey.shade200)),
              ],
            ),
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedHelpCircle,
            title: 'help_center'.tr,
            onTap: () {
              Get.toNamed(AppRoutes.helpCenterView);
            },
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedTask01,
            title: 'terms_of_use'.tr,
            onTap: () {
              Get.toNamed(AppRoutes.termsOfUse);//termsOfUse
            },
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedSquareLock01,
            title: 'privacy_policy'.tr,
            onTap: () {
              Get.toNamed(AppRoutes.privacyPolicy);
            },
          ),
          BuildTileWigets(
            icon: HugeIcons.strokeRoundedInformationCircle,
            title: 'about_chatify'.tr,
            onTap: () {
              Get.toNamed(AppRoutes.aboutChatify);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading:
                const Icon(HugeIcons.strokeRoundedLogout01, color: Colors.red),
            title: Text(
              'logout'.tr,
              style: TextStyle(color: Colors.red),
            ),
            // onTap: () => authController.logout(),
            onTap: () {
              showModalBottomSheet(
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
                        Text(
                          'logout'.tr,
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
                        Text('are_you_sure_logout'.tr),
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
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2),
                                  ),
                                  child: Text(
                                    'cancel'.tr,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
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
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Text(
                                    'yes_logout'.tr,
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
