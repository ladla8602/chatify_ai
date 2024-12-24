import 'package:chatify_ai/controllers/auth_controller.dart';
import 'package:chatify_ai/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:hugeicons/hugeicons.dart';

import '../constants/constants.dart';

class DrawerWigets extends StatelessWidget {
  const DrawerWigets({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 110,
            child: DrawerHeader(
              decoration: BoxDecoration(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/29850612/pexels-photo-29850612/free-photo-of-stylish-man-posing-by-waterfront-at-twilight.jpeg?auto=compress&cs=tinysrgb&w=400'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Andrew Ainsley',
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'andrew83@gmail.com',
                          style: TextStyle(
                            // color: Colors.grey.shade100,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.upgrade);
            },
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: ColorConstant.primaryColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                        Positioned(
                          top: -6,
                          left: 0,
                          child: CircleAvatar(
                            radius: 3,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: -4,
                          left: 10,
                          child: CircleAvatar(
                            radius: 1,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: 0,
                          child: CircleAvatar(
                            radius: 2,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          left: 0,
                          child: CircleAvatar(
                            radius: 2,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 10,
                          child: CircleAvatar(
                            radius: 1,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 1,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upgrade to PRO!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Enjoy all the benefits and explore more features!',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      HugeIcons.strokeRoundedArrowRight01,
                      color: Colors.white,
                      size: 18,
                    )
                  ],
                )),
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedAdd01, size: 18),
            title: Text(
              'New Chat',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedImage01, size: 18),
            title: Text(
              'Image generate',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(
              HugeIcons.strokeRoundedMic01,
              size: 18,
            ),
            title: Text(
              'Audio generate',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedClock04, size: 18),
            title: Text(
              'History',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedSettings02, size: 18),
            title: Text(
              'Settings',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(
              HugeIcons.strokeRoundedLogout03,
              size: 18,
            ),
            title: Text(
              'Log Out',
              style: TextStyle(fontSize: 15),
            ),
            onTap: () => authController.logout(),
          )
        ],
      ),
    );
  }
}
