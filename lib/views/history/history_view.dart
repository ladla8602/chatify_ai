import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class History extends StatelessWidget {
  History({super.key});

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

  final List<Map<String, dynamic>> pinneddata = [
    {
      'title': 'Hello there again!',
      'subtitle': 'How is your progress?',
    },
    {
      'title': 'Thank you!',
      'subtitle': 'Happy coding!',
    },
    {
      'title': 'Welcome to the team!',
      'subtitle': 'Let’s achieve great things together.',
    },
    {
      'title': 'Reminder',
      'subtitle': 'Don’t forget to complete your task.',
    },
    {
      'title': 'Update available',
      'subtitle': 'Please update your app to the latest version.',
    },
    {
      'title': 'Good job!',
      'subtitle': 'Keep up the great work.',
    },
    {
      'title': 'Let’s connect',
      'subtitle': 'Can we discuss the project tomorrow?',
    },
    {
      'title': 'Important Notice',
      'subtitle': 'Server maintenance is scheduled for tonight.',
    },
    {
      'title': 'Congratulations!',
      'subtitle': 'You’ve reached a new milestone.',
    },
    {
      'title': 'Hello Friend!',
      'subtitle': 'Hope you are doing well today.',
    },
  ];

  List<Map<String, dynamic>> sharedata = [
    {
      'title': 'Share Progress',
      'subtitle': 'Let others know about your progress!',
    },
    {
      'title': 'Thank You Note',
      'subtitle': 'Send a thank you message to your team.',
    },
    {
      'title': 'Welcome Message',
      'subtitle': 'Welcome new members to the team.',
    },
    {
      'title': 'Task Reminder',
      'subtitle': 'Remind your team about pending tasks.',
    },
    {
      'title': 'App Update',
      'subtitle': 'Share the latest app updates with friends.',
    },
    {
      'title': 'Motivational Message',
      'subtitle': 'Send a motivational message to colleagues.',
    },
    {
      'title': 'Project Discussion',
      'subtitle': 'Plan the next steps for the project.',
    },
    {
      'title': 'Server Notice',
      'subtitle': 'Inform everyone about scheduled maintenance.',
    },
    {
      'title': 'Celebrate Milestones',
      'subtitle': 'Share achievements with your network.',
    },
    {
      'title': 'Daily Greeting',
      'subtitle': 'Send warm greetings to your friends.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(child: Text('History')),
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(HugeIcons.strokeRoundedSearch01),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.shade300,
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
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
            SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                children: [
                  //1
                  ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final data = chatdata[index];
                        return ListTile(
                          leading: Icon(HugeIcons.strokeRoundedMessage01),
                          title: Text(
                            data['title'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            data['subtitle'],
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Icon(HugeIcons.strokeRoundedMoreVertical),
                        );
                      }),

                  //2
                  ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final data = pinneddata[index];
                        return ListTile(
                          leading: Icon(HugeIcons.strokeRoundedPin),
                          title: Text(
                            data['title'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            data['subtitle'],
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Icon(HugeIcons.strokeRoundedMoreVertical),
                        );
                      }),
                  //3
                  ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final data = sharedata[index];
                        return ListTile(
                          leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, border: Border.all()),
                              child: Icon(HugeIcons.strokeRoundedLink01)),
                          title: Text(
                            data['title'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            data['subtitle'],
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Icon(HugeIcons.strokeRoundedMoreVertical),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
