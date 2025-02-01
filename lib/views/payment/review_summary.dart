import 'package:chatify_ai/routes/app_routes.dart';
import 'package:chatify_ai/views/common/button_wigets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class ReviewSummary extends StatefulWidget {
  const ReviewSummary({super.key});

  @override
  // ignore: library_private_types_in_public_api
  State<ReviewSummary> createState() => _ReviewSummaryState();
}

class _ReviewSummaryState extends State<ReviewSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Review Summary'.tr,
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Text('Basic Plan',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('\$ 1000 ',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      Text('/ month',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 15),
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(HugeIcons.strokeRoundedTick02,
                                  size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Access to all features'.tr,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Selected Payment Method',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.network(
                        'https://cdn-icons-png.flaticon.com/128/16009/16009219.png',
                        width: 40,
                      ),
                      SizedBox(width: 16),
                      Text(
                        '********5567',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Spacer(),
                      Text(
                        'Change',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.green),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButtonWigets(
              text: 'Continue Payment -\4.99',
              onClick: () {
                Get.toNamed(AppRoutes.successfullyScreen);
              },
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ]),
        ));
  }
}
