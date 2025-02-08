import 'dart:async';

import 'package:chatify_ai/controllers/plan_controller.dart';
import 'package:chatify_ai/views/common/button_wigets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../controllers/subscription_controller.dart';

class UpgradeView extends StatefulWidget {
  const UpgradeView({super.key});

  @override
  State<UpgradeView> createState() => _UpgradeViewState();
}

class _UpgradeViewState extends State<UpgradeView> {
  final subscriptionController = Get.find<SubscriptionController>();
  Future<bool> subscripeToProduct() async {
    final completer = Completer<bool>();

    final paymentIntent = await subscriptionController
        .createSubscription('price_1QoeUZLG0TY6E07f8TGomsDk')
        .onError((error, stackTrace) {
      print(error);
      print(stackTrace);

      return '';
    });

    if (paymentIntent.isEmpty) {
      return false;
    }
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: paymentIntent,
      merchantDisplayName: 'Chatify AI',
    ));

    await Stripe.instance.presentPaymentSheet().then((_) async {
      // we wait for the payment on the server to be validated ( optional )
      // subscripped.value =
      //     await repo.waitForActiveSupscriptionOnProduct(product.id);
      // completer.complete(subscripped.value);
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      completer.complete(false);
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final PlanController planController = Get.put(PlanController());
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text('upgrade_to_pro'.tr, style: TextStyle(fontSize: 17)),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 18),
        itemBuilder: (context, index) {
          return UpgradeWigets(
            index: index,
            title: planController.plan[index]['title'],
            plan: planController.plan[index]['plan'],
            content: planController.plan[index]['content'],
            manualPlan: planController.plan[index]['manualPlan'],
            onClick: () {
              subscripeToProduct();
            },
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 18);
        },
        itemCount: planController.plan.length,
      ),
    );
  }
}

class UpgradeWigets extends StatelessWidget {
  final int index;
  final String title;
  final String plan;
  final String content;
  final String manualPlan;
  final void Function()? onClick;
  const UpgradeWigets({
    super.key,
    required this.index,
    required this.title,
    required this.plan,
    required this.content,
    this.onClick,
    required this.manualPlan,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> contentList =
        content.split(',').map((e) => e.trim()).toList();
    return Container(
      padding: EdgeInsets.all(14),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: plan,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  TextSpan(
                    text: '/',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  TextSpan(
                    text: manualPlan,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  )
                ]),
              ),
              SizedBox(height: 20),
              Column(
                children: contentList
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 8,
                              child: const Icon(HugeIcons.strokeRoundedTick02,
                                  size: 15),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 18),
              Divider(
                color: Colors.grey.shade300,
              ),
              SizedBox(height: 18),
              ElevatedButtonWigets(
                text: 'Select Plan',
                onClick: onClick,
                backgroundColor: Theme.of(context).primaryColor,
              )
            ],
          ),
          if (index == 1)
            Positioned(
              right: -14,
              top: -14,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(14)),
                ),
                child: Text(
                  'Most Popular',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
        ],
      ),
    );
  }
}
