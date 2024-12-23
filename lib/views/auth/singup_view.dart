import 'package:chatify_ai/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../controllers/auth_controller.dart';
import '../common/button_wigets.dart';

class SingupView extends StatelessWidget {
  const SingupView({super.key});
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
            Text("Create an account",
                style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 10),
            Text(
              "We will send a verification link to the email you entered.",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
            SizedBox(height: 50),
            Text('Email'),
            SizedBox(height: 10),
            TextFormField(
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.bottom,
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
                const Text("I agree to Carzo ", style: TextStyle(fontSize: 13)),
                Text("Terms & Conditions",
                    style: TextStyle(
                        color: ColorConstant.primaryColor, fontSize: 13)),
              ],
            ),
            SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?',
                    style: TextStyle(fontSize: 13)),
                SizedBox(width: 5),
                Text('Sign In',
                    style: TextStyle(
                        fontSize: 13, color: ColorConstant.primaryColor)),
              ],
            ),
            SizedBox(height: 20),
            Spacer(),
            ElevatedButtonWigets(
              text: 'Sign up',
              onClick: () {},
              backgroundColor: ColorConstant.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
