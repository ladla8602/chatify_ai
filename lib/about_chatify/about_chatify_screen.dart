import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';

class AboutChatifyScreen extends StatelessWidget {
  const AboutChatifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Chatify'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                child: SvgPicture.asset(
                  'assets/icons/chatify_logo.svg',
                  height: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Chatify v12.5.6',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Feedback',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Icon(HugeIcons.strokeRoundedArrowRight01),
                ],
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rate Us',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Icon(HugeIcons.strokeRoundedArrowRight01),
                ],
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Visit Our Website',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Icon(HugeIcons.strokeRoundedArrowRight01),
                ],
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Follw us on Social Media ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Icon(HugeIcons.strokeRoundedArrowRight01),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
