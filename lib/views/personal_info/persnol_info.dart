import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'personal_infos'.tr,
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/128/8984/8984545.png'),
              radius: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'full_name'.tr,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                    hintText: "Andrew Ainsley",
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'email_address'.tr,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                    hintText: "example@gmail.com",
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'app_version'.tr,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                    hintText: "1.0.0",
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(height: 10),
              ],
            )
          ],
        ),
      ),
    );
  }
}
