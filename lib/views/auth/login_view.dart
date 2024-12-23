import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/animated_text.dart';
import '../../widgets/typewriter.dart';
import '../common/button_wigets.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController _authController = Get.find();
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ColorFiltered(
            colorFilter:
                const ColorFilter.mode(Colors.black54, BlendMode.darken),
            child: Image.asset("assets/images/Splash.png",
                height: double.infinity, fit: BoxFit.cover),
          ),
          Column(
            children: [
              SizedBox(height: height * 0.19),
              const SizedBox(height: 5),
              Text(
                'app_name'.tr,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'typewriter_animation_first'.tr,
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      TypewriterAnimatedText(
                        'typewriter_animation_second'.tr,
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      TypewriterAnimatedText(
                        'typewriter_animation_third'.tr,
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                    totalRepeatCount: 20,
                    stopPauseOnTap: true,
                  ),
                ),
              ),
              Spacer(),
              Obx(() {
                return SizedBox(
                  child: CommonElevatedButtonWidget(
                    isLoading: _authController.isLoading.value,
                    imagePath: SvgPicture.asset("assets/icons/google.svg"),
                    text: 'login_with_google'.tr.toUpperCase(),
                    onClick: _authController.loginWithGoogle,
                  ),
                );
              }),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onPrimary),
                      children: [
                    TextSpan(text: 'already_account'.tr),
                    TextSpan(
                      text: 'login'.tr,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EmailLoginScreen()));
                          Get.toNamed('/signin');
                        },
                    ),
                  ])),
              SizedBox(height: height * 0.025),
            ],
          ),
        ],
      ),
    );
  }
}
