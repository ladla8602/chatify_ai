import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CommonPageView extends StatelessWidget {
  const CommonPageView({super.key});

  @override
  Widget build(BuildContext context) {
    String title = Get.arguments ?? 'Title';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
            height: 300,
            child: Lottie.asset(
              'assets/icons/comming_soon.json',
            )),
      ),
    );
  }
}
