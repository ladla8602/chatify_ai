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

// class LoginView extends StatelessWidget {
//   const LoginView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final AuthController _authController = Get.find();
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           ColorFiltered(
//             colorFilter:
//                 const ColorFilter.mode(Colors.black54, BlendMode.darken),
//             child: Image.asset("assets/images/Splash.png",
//                 height: double.infinity, fit: BoxFit.cover),
//           ),
//           Column(
//             children: [
//               SizedBox(height: height * 0.19),
//               const SizedBox(height: 5),
//               Text(
//                 'app_name'.tr,
//                 style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).primaryColor),
//               ),
//               const SizedBox(height: 35),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: AnimatedTextKit(
//                     animatedTexts: [
//                       TypewriterAnimatedText(
//                         'typewriter_animation_first'.tr,
//                         textAlign: TextAlign.center,
//                         textStyle: const TextStyle(
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                       TypewriterAnimatedText(
//                         'typewriter_animation_second'.tr,
//                         textAlign: TextAlign.center,
//                         textStyle: const TextStyle(
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                       TypewriterAnimatedText(
//                         'typewriter_animation_third'.tr,
//                         textAlign: TextAlign.center,
//                         textStyle: const TextStyle(
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white),
//                       ),
//                     ],
//                     totalRepeatCount: 20,
//                     stopPauseOnTap: true,
//                   ),
//                 ),
//               ),
//               Spacer(),
//               Obx(() {
//                 return SizedBox(
//                   child: CommonElevatedButtonWidget(
//                     isLoading: _authController.isLoading.value,
//                     imagePath: SvgPicture.asset("assets/icons/google.svg"),
//                     text: 'login_with_google'.tr.toUpperCase(),
//                     onClick: _authController.loginWithGoogle,
//                   ),
//                 );
//               }),
//               const SizedBox(height: 20),
//               RichText(
//                   text: TextSpan(
//                       style: TextStyle(
//                           fontSize: 13,
//                           color: Theme.of(context).colorScheme.onPrimary),
//                       children: [
//                     TextSpan(text: 'already_account'.tr),
//                     TextSpan(
//                       text: 'login'.tr,
//                       style: TextStyle(color: Theme.of(context).primaryColor),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EmailLoginScreen()));
//                           Get.toNamed('/signin');
//                         },
//                     ),
//                   ])),
//               SizedBox(height: height * 0.025),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:chatify_ai/controllers/auth_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import '../../constants/constants.dart';
// import '../common/button_wigets.dart';

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
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Column(
              spacing: 20,
              children: [
                SizedBox(height: height * 0.08),
                SvgPicture.asset(
                  'assets/icons/chatify_logo.svg',
                  height: 60,
                  color: ColorConstant.primaryColor,
                ),
                Text("Let's Get Started!".tr, style: Theme.of(context).textTheme.headlineLarge),

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
                          textStyle: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
                        ),
                        TypewriterAnimatedText(
                          'typewriter_animation_second'.tr,
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
                        ),
                        TypewriterAnimatedText(
                          'typewriter_animation_third'.tr,
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
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
                  backgroundColor: ColorConstant.primaryColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?', style: TextStyle(fontSize: 13)),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.signup),
                      child: Text('Sign up', style: TextStyle(fontSize: 13, color: ColorConstant.primaryColor)),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Privacy Policy',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                    ),
                    SizedBox(width: 16),
                    Text('Terms of Service', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
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
