import 'package:chatify_ai/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> paymentMethods = [
      {
        'title': 'Paypal',
        'imagePath': 'https://cdn-icons-png.flaticon.com/128/174/174861.png'
      },
      {
        'title': 'Google Pay',
        'imagePath': 'https://cdn-icons-png.flaticon.com/512/2991/2991148.png'
      },
      {
        'title': 'Apple Pay',
        'imagePath': 'https://cdn-icons-png.flaticon.com/128/15076/15076709.png'
      },
      {
        'title': '********4678',
        'imagePath': 'https://cdn-icons-png.flaticon.com/128/16009/16009219.png'
      },
      {
        'title': '********5567',
        'imagePath': 'https://cdn-icons-png.flaticon.com/128/196/196578.png'
      }
    ]; // List<Map<String, dynamic>>
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Payment Methods',
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.addPaymentMethods);
                },
                icon: Icon(HugeIcons.strokeRoundedAdd01))
          ],
        ),
        body: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemBuilder: (context, index) {
              return PaymentMethodsWigets(
                title: paymentMethods[index]['title'],
                imagePath: paymentMethods[index]['imagePath'],
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 15);
            },
            itemCount: paymentMethods.length));
  }
}

class PaymentMethodsWigets extends StatelessWidget {
  final String title;
  final String imagePath;
  const PaymentMethodsWigets(
      {super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Spacer(),
          Text(
            'Connected',
            style: TextStyle(fontSize: 13),
          )
        ],
      ),
    );
  }
}
