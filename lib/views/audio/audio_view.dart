import 'package:audioplayers/audioplayers.dart';
import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/views/common/button_wigets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../controllers/audio_generate_controller.dart';
import '../../widgets/drawer.dart';
import '../common/wigets.dart';
import 'audio_history.dart';

class AudioGenerateView extends StatelessWidget {
  const AudioGenerateView({super.key});

  @override
  Widget build(BuildContext context) {
    final AudioGenerateController audioGenerateController =
        Get.put(AudioGenerateController());
    final AudioPlayer audioPlayer = AudioPlayer();
    Future<void> playAudio(String path) async {
      try {
        await audioPlayer.stop();
        await audioPlayer.play(AssetSource(path));
      } catch (e) {
        Get.snackbar('Error', 'Failed to play audio: $e',
            snackPosition: SnackPosition.BOTTOM);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
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
          'audio_generate'.tr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [GetPrimeWigets(), SizedBox(width: 16)],
      ),
      drawer: DrawerWigets(),
      endDrawer: AudioHistory(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Obx(() {
          final selectedIndex = audioGenerateController.isSelected.value;
          // final selectedItem =
          //     audioGenerateController.audioGenerate[selectedIndex];
          // playAudio(selectedItem['audioPath']);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 20),
                Text(
                  'voice_style'.tr,
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Wrap(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 16,
                  runSpacing: 14,
                  children: List.generate(
                    audioGenerateController.audioGenerate.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          audioGenerateController.changeSelected(index);
                          print('Selected index: $index');
                        },
                        child: AudioGenerateWigets(
                          title: audioGenerateController.audioGenerate[index]
                              ['title'],
                          isSelected:
                              audioGenerateController.isSelected == index,
                          imagePath: audioGenerateController
                              .audioGenerate[index]['imagePath'],
                          onClick: () {
                            audioGenerateController.changeSelected(index);
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "prompt".tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            Get.snackbar(
                              'information',
                              "Swipe Right to See Audio History",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              duration: Duration(seconds: 3),
                            );
                          },
                          child: Icon(
                            HugeIcons.strokeRoundedInformationCircle,
                            color: Theme.of(context).primaryColor,
                          ))
                    ],
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  maxLines: 5,
                  maxLength: 400,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1.5)),
                    hintText: "enter_prompt".tr,
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(14),
        child: ElevatedButtonWigets(
          text: 'generate'.tr,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          onClick: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            HugeIcons.strokeRoundedMultiplicationSignCircle,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Text(
                        'audio'.tr,
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey.shade200,
                            border: Border.all(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5),
                                width: 1.5)),
                      ),
                      SizedBox(height: 20),
                      ElevatedButtonWigets(
                        backgroundColor: Theme.of(context).primaryColor,
                        text: 'Download',
                        onClick: () {},
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AudioGenerateWigets extends StatelessWidget {
  final String title;

  final bool isSelected;
  final String imagePath;
  final VoidCallback onClick;
  const AudioGenerateWigets(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.imagePath,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onClick,
          child: Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1),
                image: DecorationImage(
                  image: NetworkImage(
                    imagePath,
                  ),
                  fit: BoxFit.cover,
                )),
          ),
        ),
        SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.onSurface,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
