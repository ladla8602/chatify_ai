import 'package:chatify_ai/routes/app_routes.dart';
import 'package:chatify_ai/views/common/button_wigets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class SelectPaymentMethod extends StatefulWidget {
  const SelectPaymentMethod({super.key});

  @override
  // ignore: library_private_types_in_public_api
  State<SelectPaymentMethod> createState() => _SelectPaymentMethodsState();
}

class _SelectPaymentMethodsState extends State<SelectPaymentMethod> {
  int selectedIndex = -1; // Tracks the selected payment method index

  List<Map<String, dynamic>> paymentMethods = [
    {'title': 'Paypal', 'imagePath': 'https://cdn-icons-png.flaticon.com/128/174/174861.png'},
    {'title': 'Google Pay', 'imagePath': 'https://cdn-icons-png.flaticon.com/512/2991/2991148.png'},
    {'title': 'Apple Pay', 'imagePath': 'https://cdn-icons-png.flaticon.com/128/15076/15076709.png'},
    {'title': '********4678', 'imagePath': 'https://cdn-icons-png.flaticon.com/128/16009/16009219.png'},
    {'title': '********5567', 'imagePath': 'https://cdn-icons-png.flaticon.com/128/196/196578.png'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'payment_methods'.tr,
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.addPaymentMethods);
            },
            icon: Icon(HugeIcons.strokeRoundedAdd01),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: PaymentMethodsWidget(
                      title: paymentMethods[index]['title'],
                      imagePath: paymentMethods[index]['imagePath'],
                      isSelected: selectedIndex == index,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 15);
                },
                itemCount: paymentMethods.length,
              ),
            ),
            ElevatedButtonWigets(
              text: 'Continue',
              onClick: () {
                Get.toNamed(AppRoutes.reviewSummary);
              },
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodsWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isSelected;

  const PaymentMethodsWidget({
    super.key,
    required this.title,
    required this.imagePath,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey.shade200,
          width: 2, // Highlight the border when selected
        ),
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
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          Spacer(),
          if (isSelected) // Show the check icon only if selected
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
        ],
      ),
    );
  }
}
