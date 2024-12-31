import 'package:chatify_ai/models/chat_room.model.dart';
import 'package:chatify_ai/models/chatbot.model.dart';
import 'package:chatify_ai/routes/app_routes.dart';
import 'package:chatify_ai/services/firestore_service.dart';
import 'package:chatify_ai/views/common/popup_menu_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../widgets/drawer.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = FirestoreService();
    final List<Map<String, dynamic>> chatdata = [
      {
        'title': 'Hello there, I need some help',
        'subtitle': 'Are you here?',
      },
      {
        'title': 'Good morning!',
        'subtitle': 'How can I assist you?',
      },
      {
        'title': 'Welcome to Flutter development',
        'subtitle': 'Let\'s build something amazing!',
      },
      {
        'title': 'Need assistance?',
        'subtitle': 'Feel free to ask.',
      },
      {
        'title': 'Learning ListView.builder',
        'subtitle': 'It\'s a great widget for lists.',
      },
      {
        'title': 'Customizing widgets',
        'subtitle': 'Try adding colors and styles.',
      },
      {
        'title': 'Did you know?',
        'subtitle': 'ListView has multiple constructors.',
      },
      {
        'title': 'Performance matters',
        'subtitle': 'Use builder for large lists.',
      },
      {
        'title': 'Hello there again!',
        'subtitle': 'How is your progress?',
      },
      {
        'title': 'Thank you!',
        'subtitle': 'Happy coding!',
      },
    ];
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(
                HugeIcons.strokeRoundedMenuSquare,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          title: Center(
              child: Text(
            'History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(HugeIcons.strokeRoundedSearch01),
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.grey.shade200,
              ),
              child: TabBar(
                isScrollable: false,
                indicator: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: 'Chat'),
                  Tab(text: 'Pinned'),
                  Tab(text: 'Shared'),
                ],
              ),
            ),
          ),
        ),
        drawer: DrawerWigets(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: TabBarView(
            children: [
              ListView(
                children: [
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _firestoreService.fetchChatRooms(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('No chat rooms found.');
                      }

                      final chatRooms = snapshot.data!.docs.map((e) => ChatRoom.fromFirestore(e)).toList();
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: chatRooms.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final chatRoom = chatRooms[index];
                          return ListTile(
                            onTap: () => Get.toNamed(AppRoutes.chatContentView,
                                arguments: {"chatbot": ChatBot(botId: chatRoom.botId, botName: chatRoom.botName), "chatRoomId": chatRoom.id}),
                            contentPadding: EdgeInsets.all(0),
                            leading: Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
                                child: Icon(
                                  HugeIcons.strokeRoundedMessage02,
                                  color: Colors.grey,
                                )),
                            title: Text(
                              chatRoom.lastMessage.content,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            subtitle: Text(
                              chatRoom.botId,
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: ThemedPopupMenuButton(),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              //1

              //2
              ListView(
                children: [
                  SectionHeader(
                    title: 'Today',
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final data = chatdata[index];
                        return ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
                              child: Icon(
                                HugeIcons.strokeRoundedMessage02,
                                color: Colors.grey,
                              )),
                          title: Text(
                            data['title'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: 15),
                          ),
                          subtitle: Text(
                            data['subtitle'],
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          trailing: ThemedPopupMenuButton(),
                        );
                      }),
                  SizedBox(height: 20),
                ],
              ),
              //3
              ListView(
                children: [
                  SectionHeader(
                    title: 'Today',
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final data = chatdata[index];
                      return ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
                            child: Icon(
                              HugeIcons.strokeRoundedMessage02,
                              color: Colors.grey,
                            )),
                        title: Text(
                          data['title'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 15),
                        ),
                        subtitle: Text(
                          data['subtitle'],
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        trailing: ThemedPopupMenuButton(),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Divider(
              color: Colors.grey.shade200,
            ),
          )
        ],
      ),
    );
  }
}
