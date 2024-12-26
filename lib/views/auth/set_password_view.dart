import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../constants/constants.dart';
import '../common/button_wigets.dart';

class SetPasswordView extends StatelessWidget {
  SetPasswordView({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
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
            TextFormField(
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.bottom,
              // controller: ,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
                prefixIcon: Icon(
                  HugeIcons.strokeRoundedSquareLock01,
                  color: Colors.grey,
                ),
                hintText: "*******",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.shade100,
                filled: true,
              ),
            ),

            const SizedBox(height: 50),
            // Send OTP Button
            ElevatedButtonWigets(
              text: 'Send OTP Code',
              onClick: () {
                Get.toNamed('/otpaccess');
              },
              backgroundColor: ColorConstant.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
