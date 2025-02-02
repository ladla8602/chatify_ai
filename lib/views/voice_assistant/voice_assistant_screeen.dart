import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/voice_assistant_controller.dart';

class VoiceAssistantChatScreen extends StatefulWidget {
  const VoiceAssistantChatScreen({super.key});

  @override
  State<VoiceAssistantChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceAssistantChatScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late VoiceAssistantController _voiceAssistantController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _voiceAssistantController = Get.put(VoiceAssistantController(animationController: _animationController));
  }

  @override
  void dispose() {
    _animationController.dispose();
    Get.delete<VoiceAssistantController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 50),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            Obx(() {
              return Expanded(
                child: Column(
                  children: [
                    Text(_voiceAssistantController.isListening.value ? 'Go ahead, I’m listening . . .' : 'Click on mic button to start voice chatting.'),
                    const SizedBox(height: 16),
                    LottieBuilder.asset(
                      controller: _animationController,
                      width: 305,
                      'assets/lotties/voiceassistant.json',
                      delegates: LottieDelegates(
                        values: [
                          ValueDelegate.color(
                            const ['Untitled-1 Outlines', 'Group 1', 'Fill 1', '**'],
                            value: Theme.of(context).primaryColor,
                          ),
                          ValueDelegate.color(
                            const ['Untitled-1 Outlines', 'Group 2', 'Fill 1', '**'],
                            value: Theme.of(context).primaryColor,
                          ),
                          ValueDelegate.color(
                            const ['Shape Layer 1', 'Ellipse 1', 'Fill 1', '**'],
                            value: const Color(0xff5B5B5B),
                          ),
                          ValueDelegate.color(
                            const ['Shape Layer 2', 'Ellipse 1', 'Fill 1', '**'],
                            value: const Color(0xff5B5B5B),
                          ),
                          ValueDelegate.color(
                            const ['Shape Layer 3', 'Ellipse 1', 'Fill 1', '**'],
                            value: const Color(0xff5B5B5B),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  HugeIcons.strokeRoundedInformationCircle,
                  size: 12,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text.rich(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.outlineVariant),
                    TextSpan(
                      text: 'Go to premium',
                      children: [
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: 'Upgrade now',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to subscription screen
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(),
                GestureDetector(
                  onTap: _voiceAssistantController.isListening.value ? _voiceAssistantController.stopRecording : _voiceAssistantController.startRecording,
                  child: Container(
                    height: 80,
                    width: 80,
                    padding: const EdgeInsets.all(22),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff1A1A40),
                          Color(0xff1A1A40),
                        ],
                      ),
                      border: Border(
                        top: BorderSide(
                          width: 4,
                          color: Color(0xff262660),
                        ),
                        left: BorderSide(
                          width: 4,
                          color: Color(0xff262660),
                        ),
                        right: BorderSide(
                          width: 4,
                          color: Color(0xff262660),
                        ),
                      ),
                    ),
                    child: Icon(_voiceAssistantController.isListening.value ? HugeIcons.strokeRoundedPause : HugeIcons.strokeRoundedMic01),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    child: Icon(HugeIcons.strokeRoundedTime01),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 36,
            width: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff1C1C1C)),
            child: Icon(
              Icons.chevron_left,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
        ),
        Obx(() {
          return Text(
            _voiceAssistantController.isListening.value ? "Listening..." : 'Voice Assistant',
            style: Theme.of(context).textTheme.titleLarge,
          );
        }),
        GestureDetector(
          onTap: () {
            // Navigate to settings
          },
          child: const Icon(
            HugeIcons.strokeRoundedSetting06,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
