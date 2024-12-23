import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../constants/constants.dart';
import '../../controllers/auth_controller.dart';
import '../common/button_wigets.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome back👋",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              "Please enter your email & password to sign in.",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
            SizedBox(height: 50),
            Text('Email'),
            SizedBox(height: 10),
            TextFormField(
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.bottom,
              // controller: ,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  HugeIcons.strokeRoundedMail01,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
                hintText: "Email",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.shade100,
                filled: true,
              ),
            ),
            SizedBox(height: 24),
            Text('Password'),
            SizedBox(height: 10),
            TextFormField(
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.bottom,
              // controller: ,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
                prefixIcon: Icon(HugeIcons.strokeRoundedLockPassword),
                suffixIcon: Icon(HugeIcons.strokeRoundedEye),
                hintText: "Password",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.shade100,
                filled: true,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () {
                    return Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      value: authController.checkbox.value,
                      onChanged: (value) =>
                          authController.toggleCheckbox(value),
                      activeColor: ColorConstant.primaryColor,
                    );
                  },
                ),
                SizedBox(width: 10),
                const Text("Remember me ", style: TextStyle(fontSize: 13)),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/forgotpassword');
                  },
                  child: Text("Forgot Password?",
                      style: TextStyle(
                          color: ColorConstant.primaryColor, fontSize: 13)),
                ),
              ],
            ),
            SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?', style: TextStyle(fontSize: 13)),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () => Get.toNamed('/signup'),
                  child: Text('Sign up',
                      style: TextStyle(
                          fontSize: 13, color: ColorConstant.primaryColor)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Spacer(),
            ElevatedButtonWigets(
              text: 'Sign in',
              onClick: () {},
              backgroundColor: ColorConstant.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
