import 'package:chatify_ai/constants/constants.dart';
import 'package:chatify_ai/controllers/plan_controller.dart';
import 'package:chatify_ai/views/common/button_wigets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons/hugeicons.dart';

class UpgradeView extends StatelessWidget {
  const UpgradeView({super.key});

  @override
  Widget build(BuildContext context) {
    final PlanController _planController = Get.put(PlanController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text('Upgrade to PRO!', style: TextStyle(fontSize: 17)),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return UpgradeWigets(
            index: index,
            title: _planController.plan[index]['title'],
            plan: _planController.plan[index]['plan'],
            content: _planController.plan[index]['content'],
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 10);
        },
        itemCount: _planController.plan.length,
      ),
    );
  }
}

class UpgradeWigets extends StatelessWidget {
  final int index;
  final String title;
  final String plan;
  final String content;

  const UpgradeWigets(
      {super.key,
      required this.index,
      required this.title,
      required this.plan,
      required this.content});

  @override
  Widget build(BuildContext context) {
    final List<String> contentList =
        content.split(',').map((e) => e.trim()).toList();
    return Container(
      padding: EdgeInsets.all(14),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade200,
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
              Text(
                plan,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Column(
                children: contentList
                    .map((item) => Row(
                          children: [
                            const Icon(HugeIcons.strokeRoundedTick02, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
              SizedBox(height: 18),
              Divider(
                color: Colors.grey.shade300,
              ),
              SizedBox(height: 18),
              ElevatedButtonWigets(
                text: 'Select Plan',
                onClick: () {},
                backgroundColor: ColorConstant.primaryColor,
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
                  color: ColorConstant.primaryColor,
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
