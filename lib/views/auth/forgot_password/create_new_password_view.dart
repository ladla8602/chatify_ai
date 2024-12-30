import 'package:chatify_ai/routes/app_routes.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../constants/constants.dart';
import '../../../controllers/auth_controller.dart';
import '../../common/button_wigets.dart';
import '../../common/dialog_wigets.dart';

class CreateNewPasswordView extends StatelessWidget {
  const CreateNewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create New Password 🔑",
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                  "Create your new password if you forgot it.then you have to do forgot password.",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
                SizedBox(height: 50),
                Text('New Password'),
                SizedBox(height: 10),
                TextFormField(
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.bottom,
                  controller: emailController,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    prefixIcon: Icon(HugeIcons.strokeRoundedLockPassword),
                    suffixIcon: Icon(HugeIcons.strokeRoundedEye),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 28),
                    hintText: "Password",
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                Text('Confirm Password'),
                SizedBox(height: 10),
                TextFormField(
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.bottom,
                  controller: passwordController,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 28),
                    prefixIcon: Icon(HugeIcons.strokeRoundedLockPassword),
                    suffixIcon: Icon(HugeIcons.strokeRoundedEye),
                    hintText: "Confirm Password",
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Spacer(),
                Obx(() {
                  return authController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButtonWigets(
                          text: 'Save New Password',
                          onClick: () async {
                            // if (_formKey.currentState!.validate()) {
                            //   // Show loader

                            // }
                            showCustomDialog(
                              context,
                              title: 'Reset Password\nSuccessful!',
                              icon: HugeIcons.strokeRoundedSquareLock02,
                              message:
                                  ' Please wait...\nYou will be directed to the homepage ',
                              widget: CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                                strokeWidth: 5,
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          },
                          backgroundColor: Theme.of(context).primaryColor,
                        );
                }),
              ],
            ),
          ),
        ));
  }
}
