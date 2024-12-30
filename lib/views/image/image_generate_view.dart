import 'package:audioplayers/audioplayers.dart';
import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/controllers/image_generator.dart';
import 'package:chatify_ai/routes/app_routes.dart';
import 'package:chatify_ai/views/common/button_wigets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../common/wigets.dart';

class ImageGenerateView extends StatelessWidget {
  const ImageGenerateView({super.key});
  @override
  Widget build(BuildContext context) {
    final ImageGeneratorController imageGeneratorController =
        Get.put(ImageGeneratorController());
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Image Generate',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        actions: [GetPrimeWigets(), SizedBox(width: 16)],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Obx(() {
          final selectedIndex = imageGeneratorController.isSelected.value;
          final selectedItem =
              imageGeneratorController.imageGenerate[selectedIndex];
          playAudio(selectedItem['audioPath']);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  imageGeneratorController.imageGenerate.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        imageGeneratorController.changeSelected(index);
                        print('Selected index: $index');
                      },
                      child: ImageGenerateWigets(
                        title: imageGeneratorController.imageGenerate[index]
                            ['title'],
                        color: imageGeneratorController.imageGenerate[index]
                            ['color'],
                        isSelected:
                            imageGeneratorController.isSelected == index,
                        imagePath: imageGeneratorController.imageGenerate[index]
                            ['imagePath'],
                        onClick: () {
                          imageGeneratorController.changeSelected(index);
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Prompt",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                maxLines: 6,
                maxLength: 460,
                style: TextStyle(),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: ColorConstant.primaryColor, width: 1.5)),
                  hintText: "Enter your prompt...",
                  hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
              ),
              Spacer(),
              ElevatedButtonWigets(
                text: 'Generate',
                backgroundColor: ColorConstant.primaryColor,
                foregroundColor: Colors.white,
                onClick: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        backgroundColor: Colors.white,
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
                                  HugeIcons
                                      .strokeRoundedMultiplicationSignCircle,
                                  color: ColorConstant.primaryColor,
                                ),
                              ),
                            ),
                            Text(
                              'Image Generate',
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey.shade200,
                                  border: Border.all(
                                      color: ColorConstant.primaryColor
                                          .withOpacity(0.5),
                                      width: 1.5)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                    'https://img.freepik.com/premium-vector/vector-young-man-anime-style-character-vector-illustration-design-manga-anime-boy_147933-12445.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid'),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButtonWigets(
                              backgroundColor: ColorConstant.primaryColor,
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
              SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }
}

class ImageGenerateWigets extends StatelessWidget {
  final String title;
  final Color color;
  final bool isSelected;
  final String imagePath;
  final VoidCallback onClick;
  const ImageGenerateWigets(
      {super.key,
      required this.title,
      required this.color,
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
            width: 105,
            height: 150,
            decoration: BoxDecoration(
                color: isSelected
                    ? ColorConstant.primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isSelected
                        ? ColorConstant.primaryColor
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
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: isSelected ? ColorConstant.primaryColor : Colors.black,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
