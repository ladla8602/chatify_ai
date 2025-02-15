import 'package:chatify_ai/controllers/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.put(LanguageController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'language'.tr,
          style: TextStyle(fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         if (languageController.selectedLanguage.value.isNotEmpty) {
        //           Get.back();
        //         } else {
        //           Get.snackbar(
        //             'Error'.tr,
        //             'Please select a language first.'.tr,
        //             snackPosition: SnackPosition.BOTTOM,
        //           );
        //         }
        //       },
        //       icon: Icon(HugeIcons.strokeRoundedTick01)),
        // ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        separatorBuilder: (context, index) => SizedBox(height: 14),
        itemCount: languageController.languages.length,
        itemBuilder: (context, index) {
          final language = languageController.languages[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: languageController.selectedLanguage.value == language.name ? Theme.of(context).primaryColor : Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              leading: Text(
                language.flag,
                style: TextStyle(fontSize: 24),
              ),
              title: Text(
                language.name,
                style: TextStyle(fontSize: 14),
              ),
              trailing: languageController.selectedLanguage.value == language.name
                  ? Icon(
                      HugeIcons.strokeRoundedCheckmarkCircle02,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
              onTap: () => languageController.changeLanguage(language),
            ),
          );
        },
      ),
    );
  }
}
