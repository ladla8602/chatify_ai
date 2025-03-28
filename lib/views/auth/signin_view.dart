import 'package:chatify_ai/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../controllers/auth_controller.dart';
import '../common/button_wigets.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Obx(() {
            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome back👋", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
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
                    controller: emailController,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        HugeIcons.strokeRoundedMail01,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
                      hintText: "Email",
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      } else if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Text('Password'),
                  SizedBox(height: 10),
                  TextFormField(
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.bottom,
                    controller: passwordController,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
                      prefixIcon: Icon(HugeIcons.strokeRoundedLockPassword),
                      suffixIcon: Icon(HugeIcons.strokeRoundedEye),
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Obx(
                      //   () {
                      //     return Checkbox(
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(5)),
                      //       value: authController.checkbox.value,
                      //       onChanged: (value) =>
                      //           authController.toggleCheckbox(value),
                      //       activeColor: Theme.of(context).primaryColor,
                      //     );
                      //   },
                      // ),
                      Checkbox(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        value: authController.checkbox.value,
                        onChanged: (value) => authController.toggleCheckbox(value),
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 10),
                      const Text("Remember me ", style: TextStyle(fontSize: 13)),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.forgotpassword);
                        },
                        child: Text("Forgot Password?", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13)),
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
                        onTap: () => Get.toNamed(AppRoutes.signup),
                        child: Text('Sign up', style: TextStyle(fontSize: 13, color: Theme.of(context).primaryColor)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Spacer(),
                  ElevatedButtonWigets(
                    text: 'Sign in',
                    onClick: () async {
                      if (formKey.currentState!.validate()) {
                        // Show loader
                        authController.isLoading.value = true;
                        await authController.signIn(emailController.text, passwordController.text, context);
                      }
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            );
          }),
        ));
  }
}
