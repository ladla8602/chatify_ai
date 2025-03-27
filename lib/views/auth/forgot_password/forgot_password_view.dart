import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../common/button_wigets.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Reset your Password? 🔑",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            const Text(
              "Please enter your email and we will send an OTP code in the next step to reset you password.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            // Label
            const Text(
              "Email",
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
                prefixIcon: Icon(
                  HugeIcons.strokeRoundedMail01,
                  color: Colors.grey,
                ),
                hintText: "example@yourdomain.com",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 50),
            // Send OTP Button
            ElevatedButtonWigets(
              text: 'Send OTP Code',
              onClick: () {
                Get.toNamed('/otpaccess');
              },
              backgroundColor: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
