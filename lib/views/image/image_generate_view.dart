import 'package:audioplayers/audioplayers.dart';
import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/controllers/image_gen_controller.dart';
import 'package:chatify_ai/library/flutter_chat/lib/flutter_chat.dart';
import 'package:chatify_ai/views/common/button_wigets.dart';
import 'package:chatify_ai/widgets/floating_action_bubble.dart';
import 'package:chatify_ai/widgets/not_found_widget.dart';
import 'package:chatify_ai/widgets/typing_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../widgets/drawer.dart';
import '../common/wigets.dart';

class ImageGenerateView extends StatefulWidget {
  const ImageGenerateView({super.key});

  @override
  State<ImageGenerateView> createState() => _ImageGenerateViewState();
}

class _ImageGenerateViewState extends State<ImageGenerateView> {
  late ImageGenController _imageGenController;
  @override
  void initState() {
    super.initState();
    _imageGenController = Get.find<ImageGenController>();
    initializeImageGen();
  }

  initializeImageGen() {
    _imageGenController
      ..imageGenCommand.art = 'None'
      ..imageGenCommand.lighting = 'None'
      ..imageGenCommand.mood = 'None'
      ..imageGenCommand.model = 'dall-e-2'
      ..imageGenCommand.size = imageSizeOptionsDalle2.first
      ..imageGenCommand.style = 'None';
    _imageGenController.loadInitialMessages();
  }

  @override
  Widget build(BuildContext context) {
    final ImageGenController imageGeneratorController = Get.find();
    final AudioPlayer audioPlayer = AudioPlayer();
    Future<void> playAudio(String path) async {
      try {
        await audioPlayer.stop();
        await audioPlayer.play(AssetSource(path));
      } catch (e) {
        Get.snackbar('Error', 'Failed to play audio: $e', snackPosition: SnackPosition.BOTTOM);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //
      appBar: AppBar(
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
          'Image Generate',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [GetPrimeWigets(), SizedBox(width: 16)],
      ),
      drawer: DrawerWigets(),
      endDrawer: Drawer(
        width: 280,
        child: SafeArea(
          child: Obx(() {
            return Chat(
              messages: _imageGenController.messages.toList(),
              onSendPressed: (v) {},
              user: _imageGenController.user,
              showUserAvatars: false,
              showUserNames: true,
              emptyState: _imageGenController.isDataLoadingForFirstTime.value
                  ? const Center(child: TypingLoaderWidget())
                  : NotFoundWidget(
                      title: 'no_image_generate'.tr,
                      buttonText: 'generate'.tr,
                      onButtonClick: () => Scaffold.of(context).closeEndDrawer(),
                    ),
              customBottomWidget: const SizedBox.shrink(),
              onEndReached: _imageGenController.loadInitialMessages,
              typingIndicatorOptions: TypingIndicatorOptions(
                typingUsers: _imageGenController.typingUsers,
                typingMode: TypingIndicatorMode.image,
              ),
            );
          }),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Obx(() {
                final selectedIndex = imageGeneratorController.isSelected.value;
                final selectedItem = imageGeneratorController.imageGenerate[selectedIndex];

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
                              title: imageGeneratorController.imageGenerate[index]['title'],
                              color: imageGeneratorController.imageGenerate[index]['color'],
                              isSelected: imageGeneratorController.isSelected == index,
                              imagePath: imageGeneratorController.imageGenerate[index]['imagePath'],
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Prompt",
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
                                  "Swipe Right to See Image History",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Theme.of(context).colorScheme.surface,
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
                      maxLines: 6,
                      maxLength: 460,
                      onChanged: (value) => imageGeneratorController.imageGenCommand.prompt = value,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5)),
                        hintText: "Enter your prompt...",
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              }),
            ),
          ),
          Builder(
            builder: (BuildContext context) => FloatingMenuPanel(
              positionTop: MediaQuery.of(context).size.height * 0.6,
              positionRight: -10,
              size: 50,
              panelOpenOffset: -10,
              backgroundColor: Theme.of(context).colorScheme.primary,
              panelIcon: Scaffold.of(context).isEndDrawerOpen ? Icons.chevron_right : Icons.chevron_left,
              onPressed: (index) {},
              onMainPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              buttons: [],
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(14),
        child: ElevatedButtonWigets(
          text: 'Generate',
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          onClick: () {
            _imageGenController.handleSendPressed();
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        'Image Generate',
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey.shade200,
                            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5), width: 1.5)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                              'https://img.freepik.com/premium-vector/vector-young-man-anime-style-character-vector-illustration-design-manga-anime-boy_147933-12445.jpg?uid=R118908268&ga=GA1.1.1519694566.1696227085&semt=ais_hybrid'),
                        ),
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

class ImageGenerateWigets extends StatelessWidget {
  final String title;
  final Color color;
  final bool isSelected;
  final String imagePath;
  final VoidCallback onClick;
  const ImageGenerateWigets({super.key, required this.title, required this.color, required this.isSelected, required this.imagePath, required this.onClick});

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
                color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300, width: isSelected ? 2 : 1),
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
            color: isSelected ? Theme.of(context).primaryColor : Colors.black,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
