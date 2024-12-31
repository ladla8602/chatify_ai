import 'package:chatify_ai/routes/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/constants.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/animated_text.dart';
import '../../widgets/typewriter.dart';
import '../common/button_wigets.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        // ColorFiltered(
        //   colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.darken),
        //   child: Image.asset("assets/images/Splash.png", height: double.infinity, fit: BoxFit.cover),
        // ),
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Column(
              spacing: 20,
              children: [
                SizedBox(height: height * 0.08),
                SvgPicture.asset(
                  'assets/icons/chatify_logo.svg',
                  height: 60,
                  color: Theme.of(context).primaryColor,
                ),
                Text("Let's Get Started!".tr,
                    style: Theme.of(context).textTheme.headlineLarge),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'typewriter_animation_first'.tr,
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor),
                        ),
                        TypewriterAnimatedText(
                          'typewriter_animation_second'.tr,
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor),
                        ),
                        TypewriterAnimatedText(
                          'typewriter_animation_third'.tr,
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                      totalRepeatCount: 20,
                      stopPauseOnTap: true,
                    ),
                  ),
                ),
                // Text(
                //   "Let's dive in into your account",
                //   style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                // ),
                OutlinebuttonWigets(
                  logo: 'assets/icons/google.png',
                  text: 'Continue with Google',
                  onClick: authController.loginWithGoogle,
                ),
                OutlinebuttonWigets(
                  logo: 'assets/icons/apple.png',
                  text: 'Continue with Apple',
                ),
                OutlinebuttonWigets(
                  logo: 'assets/icons/facebook.png',
                  text: 'Continue with Facebook',
                ),
                OutlinebuttonWigets(
                  logo: 'assets/icons/x.png',
                  text: 'Continue with X',
                ),
                ElevatedButtonWigets(
                  text: 'login_with_email'.tr,
                  onClick: () {
                    Get.toNamed(AppRoutes.signin);
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?',
                        style: TextStyle(fontSize: 13)),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.signup),
                      child: Text('Sign up',
                          style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).primaryColor)),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Privacy Policy',
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 11),
                    ),
                    SizedBox(width: 16),
                    Text('Terms of Service',
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 11)),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
