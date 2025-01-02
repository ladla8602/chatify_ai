import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Linked_Account extends StatelessWidget {
  const Linked_Account({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> linkedAccount = [
      {
        'title': 'Google',
        'imagePath': 'https://cdn-icons-png.flaticon.com/128/174/174861.png',
        'status': 'Connected'
      },
      {
        'title': 'Facebook ',
        'imagePath': 'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
        'status': 'Connected'
      },
      {
        'title': 'Apple',
        'imagePath':
            'https://cdn-icons-png.flaticon.com/128/15076/15076709.png',
        'status': 'Connect'
      },
      {
        'title': 'X',
        'imagePath': 'https://cdn-icons-png.flaticon.com/128/5969/5969020.png',
        'status': 'Connect',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'linked_accounts'.tr,
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemBuilder: (context, index) {
            return LinkedAccountWigets(
              imagePath: linkedAccount[index]['imagePath'],
              title: linkedAccount[index]['title'],
              status: linkedAccount[index]['status'],
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 15);
          },
          itemCount: linkedAccount.length),
    );
  }
}

class LinkedAccountWigets extends StatelessWidget {
  final String title;
  final String imagePath;
  final String status;

  const LinkedAccountWigets(
      {super.key,
      required this.title,
      required this.imagePath,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Image.network(
            imagePath,
            width: 40,
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
          ),
          Spacer(),
          Text(
            status,
            style: TextStyle(
              fontSize: 13,
              color: status == 'Connected'
                  ? Colors.black
                  : Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
