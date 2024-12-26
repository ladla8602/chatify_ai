import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/views/common/button_wigets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class AddPaymentView extends StatelessWidget {
  const AddPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cardCtlr = TextEditingController();
    final TextEditingController nameCtlr = TextEditingController();
    final TextEditingController cvvCtlr = TextEditingController();
    final TextEditingController expiryCtlr = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            HugeIcons.strokeRoundedCancel01,
            color: Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Add New Payment",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(HugeIcons.strokeRoundedIrisScan))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Card Number',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: cardCtlr,
              style: TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Enter Card Number',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Account Holder Name',
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: nameCtlr,
              style: TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Enter Name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expiry Date',
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: expiryCtlr,
                        style: TextStyle(fontSize: 15),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CVV',
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: cvvCtlr,
                        style: TextStyle(fontSize: 15),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter CVV',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Divider(
              color: Colors.grey.shade200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://cdn-icons-png.flaticon.com/128/196/196578.png',
                  width: 50,
                ),
                SizedBox(width: 10),
                Image.network(
                  'https://cdn-icons-png.flaticon.com/128/14079/14079391.png',
                  width: 40,
                ),
                SizedBox(width: 10),
                Image.network(
                  'https://cdn-icons-png.flaticon.com/128/16009/16009219.png',
                  width: 40,
                ),
                SizedBox(width: 10),
                Image.network(
                  'https://cdn-icons-png.flaticon.com/128/174/174861.png',
                  width: 40,
                )
              ],
            ),
            Spacer(),
            ElevatedButtonWigets(
              text: 'Save',
              onClick: () {},
              backgroundColor: ColorConstant.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
