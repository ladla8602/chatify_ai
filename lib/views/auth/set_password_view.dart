import 'package:chatify_ai/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../constants/constants.dart';
import '../../routes/app_routes.dart';
import '../common/button_wigets.dart';

class SetPasswordView extends StatelessWidget {
  final User? firebaseUser;
  const SetPasswordView({super.key, this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final AuthController authController = Get.find<AuthController>();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final formKey = GlobalKey<FormState>();
    Future<void> setPassword() async {
      try {
        String password = passwordController.text;

        if (password.isEmpty) {
          Get.snackbar('Error', 'Please enter a password');
          return;
        }

        // Set the password in Firebase Authentication
        await firebaseUser?.updatePassword(password);
        await auth.signInWithEmailAndPassword(
          email: firebaseUser!.email!,
          password: password,
        );

        // Navigate to chat view or any other screen
        Get.toNamed(AppRoutes.chatview);
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "Set your Password? 🔑",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              const Text(
                "Please enter your password ",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              // Label
              const Text(
                "password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                return TextFormField(
                  textAlign: TextAlign.start,
                  obscureText: !authController.passwordVisible.value,
                  textAlignVertical: TextAlignVertical.bottom,
                  controller: passwordController,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 15),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 28),
                    prefixIcon: Icon(
                      HugeIcons.strokeRoundedSquareLock01,
                      color: Colors.grey,
                    ),
                    suffixIcon: InkWell(
                        onTap: () {
                          authController.togglePasswordVisibility();
                        },
                        child: Icon(HugeIcons.strokeRoundedEye)),
                    hintText: "*******",
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.grey.shade100,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    } else {
                      return null;
                    }
                  },
                );
              }),

              const SizedBox(height: 50),
              // Send OTP Button
              ElevatedButtonWigets(
                text: 'Set Password and Login',
                onClick: () {
                  if (formKey.currentState!.validate()) {
                    setPassword();
                  }
                  // Get.toNamed('/otpaccess');
                },
                backgroundColor: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
