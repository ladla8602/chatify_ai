import 'package:chatify_ai/controllers/help_center_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons/hugeicons.dart';

class HelpCenterView extends StatefulWidget {
  const HelpCenterView({super.key});

  @override
  State<HelpCenterView> createState() => _HelpCenterViewState();
}

class _HelpCenterViewState extends State<HelpCenterView> {
  @override
  void initState() {
    super.initState();
    final HelpCenterController helpCenterController =
        Get.put(HelpCenterController());
    helpCenterController.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final HelpCenterController helpCenterController = Get.find();
    return DefaultTabController(
      length: 2,
      child: Obx(() {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Help Center'),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: TabBar(
                    indicator: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: 'FAQ'),
                      Tab(text: 'Contact us'),
                    ]),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: TabBarView(
              children: [
                ListView(
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: helpCenterController.categories.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              helpCenterController.selectCategory(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: helpCenterController
                                            .selectedCategoryIndex ==
                                        index
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                border: Border.all(
                                    color: helpCenterController
                                                .selectedCategoryIndex ==
                                            index
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade100,
                                    width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  helpCenterController.categories[index],
                                  style: TextStyle(
                                    color: helpCenterController
                                                .selectedCategoryIndex ==
                                            index
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(
                          HugeIcons.strokeRoundedSearch01,
                          size: 22,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: helpCenterController.faqItems.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade100),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: ExpansionTile(
                            initiallyExpanded: helpCenterController
                                .faqItems[index]['isExpanded'],
                            childrenPadding:
                                EdgeInsets.symmetric(horizontal: 14),
                            shape: Border(bottom: BorderSide.none),
                            title: Text(helpCenterController.faqItems[index]
                                ['question']),
                            children: [
                              Text(helpCenterController.faqItems[index]
                                  ['answer']),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16);
                    },
                    itemCount: helpCenterController.contactUs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade100),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            children: [
                              Icon(
                                  helpCenterController.contactUs[index]['icon'],
                                  color: Theme.of(context).primaryColor),
                              SizedBox(width: 12),
                              Text(helpCenterController.contactUs[index]
                                  ['title']),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
