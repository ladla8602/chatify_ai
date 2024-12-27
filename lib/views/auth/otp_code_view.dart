import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../constants/constants.dart';
import '../common/button_wigets.dart';

class OtpCodeView extends StatelessWidget {
  OtpCodeView({super.key});

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
              "Enter OTP Code 🔒",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            const Text(
              "Check your email for the OTP code we sent\nyou. Enter the code below to continue resetting\n your password.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 30),
            // OTP Input Field
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 60,
                child: Pinput(
                  // controller: ,
                  keyboardType: TextInputType.number,
                  length: 4,
                  defaultPinTheme: PinTheme(
                    width: 58,
                    height: 58,
                    textStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 58,
                    height: 58,
                    textStyle:
                        const TextStyle(fontSize: 18, color: Colors.black),
                    decoration: BoxDecoration(
                      color: ColorConstant.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ColorConstant.primaryColor),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 58,
                    height: 58,
                    textStyle:
                        const TextStyle(fontSize: 15, color: Colors.black),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  showCursor: true,
                  onCompleted: (pin) {
                    print("Entered Code: $pin");
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Countdown Timer and Resend Link
            Align(
              alignment: Alignment.center,
              child: Text(
                "You can resend the code now.",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Resend code",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            // const SizedBox(height: 45),
            Spacer(),

            ElevatedButtonWigets(
              text: 'Submit',
              onClick: () {},
              backgroundColor: ColorConstant.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
