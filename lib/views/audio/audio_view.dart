import 'package:audioplayers/audioplayers.dart';
import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/views/common/button_wigets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../controllers/audio_generate_controller.dart';
import '../../library/flutter_chat/lib/flutter_chat.dart';
import '../../library/flutter_chat/lib/src/widgets/chat.dart';
import '../../widgets/drawer.dart';
import '../../widgets/floating_action_bubble.dart';
import '../../widgets/not_found_widget.dart';
import '../../widgets/typing_loader.dart';
import '../common/wigets.dart';

class AudioGenerateView extends StatefulWidget {
  const AudioGenerateView({super.key});

  @override
  State<AudioGenerateView> createState() => _AudioGenerateViewState();
}

class _AudioGenerateViewState extends State<AudioGenerateView> {
  final AudioPlayer audioPlayer = AudioPlayer();
  late AudioGenerateController audioGenController;
  int _selectedChipIndex = 0;

  @override
  void initState() {
    super.initState();
    Get.put(AudioGenerateController());
    audioGenController = Get.find<AudioGenerateController>();
    initializeAudioGen();
  }

  initializeAudioGen() {
    audioGenController
      ..speechGenCommand.text = ''
      ..speechGenCommand.voice = 'alloy';

    audioGenController.loadInitialMessages();
  }

  Future<void> _handleGenerate(BuildContext context) async {
    if (audioGenController.promptController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter text to generate audio',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    audioGenController.speechGenCommand
      ..text = audioGenController.promptController.text.trim()
      ..voice = audioGenController
          .audioGenerate[audioGenController.isSelected.value]['voice'];

    await audioGenController.handleSendPressed();
  }

  @override
  Widget build(BuildContext context) {
    final AudioGenerateController audioGenerateController = Get.find();
    // Future<void> playAudio(String path) async {
    //   try {
    //     await audioPlayer.stop();
    //     await audioPlayer.play(AssetSource(path));
    //   } catch (e) {
    //     Get.snackbar('Error', 'Failed to play audio: $e',
    //         snackPosition: SnackPosition.BOTTOM);
    //   }
    // }

    return Scaffold(
      key: audioGenController.scaffoldKey,
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
      endDrawerEnableOpenDragGesture: false,
      onEndDrawerChanged: (isOpened) =>
          audioGenController.isDrawerOpen.value = isOpened,
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SafeArea(
          child: Obx(() {
            return Chat(
              messages: audioGenController.messages.toList(),
              onSendPressed: (v) {},
              user: audioGenController.user,
              showUserAvatars: false,
              showUserNames: true,
              emptyState: audioGenController.isDataLoadingForFirstTime.value
                  ? const Center(child: TypingLoaderWidget())
                  : NotFoundWidget(
                      title: 'No audio genrated!',
                      buttonText: 'generate'.tr,
                      onButtonClick: () =>
                          Scaffold.of(context).closeEndDrawer(),
                    ),
              customBottomWidget: const SizedBox.shrink(),
              onEndReached: audioGenController.loadInitialMessages,
              typingIndicatorOptions: TypingIndicatorOptions(
                typingUsers: audioGenController.typingUsers,
                typingMode: TypingIndicatorMode.image,
              ),
              theme: Theme.of(context).brightness == Brightness.dark
                  ? DarkChatTheme(
                      primaryColor: Theme.of(context).colorScheme.surface,
                      secondaryColor: Theme.of(context).colorScheme.surface,
                    )
                  : const DefaultChatTheme(),
            );
          }),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Obx(() {
              // final selectedIndex = audioGenerateController.isSelected.value;
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
                        audioGenController.audioGenerate.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              audioGenController.changeSelected(index);
                              print('Selected index: $index');
                            },
                            child: AudioGenerateWigets(
                              title: audioGenController.audioGenerate[index]
                                  ['title'],
                              isSelected:
                                  audioGenController.isSelected == index,
                              imagePath: audioGenController.audioGenerate[index]
                                  ['imagePath'],
                              onClick: () {
                                audioGenController.changeSelected(index);
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
                      controller: audioGenerateController.promptController,
                      onChanged: (value) =>
                          audioGenerateController.speechGenCommand.text ==
                          value,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1.5)),
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
          Builder(
            builder: (BuildContext context) => Obx(() => FloatingMenuPanel(
                  positionTop: MediaQuery.of(context).size.height * 0.6,
                  positionRight: -10,
                  size: 50,
                  panelOpenOffset: -10,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  panelIcon: audioGenController.isDrawerOpen.value
                      ? Icons.chevron_right
                      : Icons.chevron_left,
                  onPressed: (index) {},
                  onMainPressed: audioGenController.toggleDrawer,
                  buttons: const [], // Add your menu buttons here
                )),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(14),
        child: Obx(
          () => ElevatedButtonWigets(
            isLoading: audioGenController.isGenerating.value,
            text: 'generate'.tr,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            onClick: () => _handleGenerate(context),
          ),
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
