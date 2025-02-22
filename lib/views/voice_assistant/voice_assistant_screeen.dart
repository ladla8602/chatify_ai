import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/voice_assistant_controller.dart';
import '../../routes/app_routes.dart';

class VoiceAssistantChatScreen extends StatefulWidget {
  const VoiceAssistantChatScreen({super.key});

  @override
  State<VoiceAssistantChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceAssistantChatScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late VoiceAssistantController _voiceAssistantController;

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
                    Text(_voiceAssistantController.isListening.value ? 'go_ahead'.tr : 'click_on_mic'.tr),
                    const SizedBox(height: 22),
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
          color: Theme.of(context).colorScheme.surface,
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
                      text: 'go_to_premium'.tr,
                      children: [
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: 'upgrade_now'.tr,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to subscription screen
                              Get.toNamed(AppRoutes.upgrade);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 45,
                  ),
                  GestureDetector(
                    onTap: _voiceAssistantController.isListening.value ? _voiceAssistantController.stopRecording : _voiceAssistantController.startRecording,
                    child: Container(
                      height: 80,
                      width: 80,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primary,
                          ],
                        ),
                      ),
                      child: Icon(
                        _voiceAssistantController.isListening.value ? HugeIcons.strokeRoundedPause : HugeIcons.strokeRoundedMic01,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        HugeIcons.strokeRoundedMultiplicationSign,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    Get.delete<VoiceAssistantController>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _voiceAssistantController = Get.put(VoiceAssistantController(animationController: _animationController));
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
          ),
        ),
        Obx(() {
          return Text(
            _voiceAssistantController.isListening.value ? "listening".tr : 'voice_assistant'.tr,
            style: Theme.of(context).textTheme.titleLarge,
          );
        }),
        GestureDetector(
          onTap: () {
            // Navigate to settings
          },
          child: const Icon(
            HugeIcons.strokeRoundedSetting06,
          ),
        ),
      ],
    );
  }
}
