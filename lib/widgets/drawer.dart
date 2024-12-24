import 'package:chatify_ai/views/history/history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons/hugeicons.dart';

import '../constants/constants.dart';

class DrawerWigets extends StatelessWidget {
  const DrawerWigets({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: ColorConstant.primaryColor,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/29850612/pexels-photo-29850612/free-photo-of-stylish-man-posing-by-waterfront-at-twilight.jpeg?auto=compress&cs=tinysrgb&w=400'),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Andrew Ainsley',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'andrew83@gmail.com',
                        style: TextStyle(
                          color: Colors.grey.shade100,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedAdd01),
            title: Text(
              'New Chat',
              style: TextStyle(fontSize: 16,),
            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedImage01),
            title: Text(
              'Image generate',
              style: TextStyle(fontSize: 16,),

            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedMic01),
            title: Text(
              'Audio generate',
              style: TextStyle(fontSize: 16,),
            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedClock04),
            title: Text(
              'History',
           style: TextStyle(fontSize: 16,),
            ),
            onTap: () {
              // Handle item tap
               Get.toNamed('/history'); 
            
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedSettings02),
            title: Text(
              'Settings',
            style: TextStyle(fontSize: 16,),
            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedStar),
            title: Text(
              'Rate App',
            style: TextStyle(fontSize: 16,),
            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedShare08),
            title: Text(
              'share App',
           style: TextStyle(fontSize: 16,),
            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedMore),
            title: Text(
              'About Us',
           style: TextStyle(fontSize: 16,),
            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(HugeIcons.strokeRoundedLogout03),
            title: Text(
              'Log Out',
             style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              // Handle item tap
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
