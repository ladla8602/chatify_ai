import 'package:flutter/material.dart';

showCustomDialog(BuildContext context, {IconData? icon, String? title, String? message, required Widget widget}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        // title: Text('Password has been changed'),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 40,
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: CircleAvatar(
                      radius: 2,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Positioned(
                    left: -15,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Positioned(
                    left: -15,
                    top: 26,
                    child: CircleAvatar(
                      radius: 2,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Positioned(
                    bottom: -5,
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Positioned(
                    right: -15,
                    top: 20,
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Positioned(
                    right: -10,
                    top: 50,
                    child: CircleAvatar(
                      radius: 2,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 22),
              Text(
                title ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                message ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 22),
              widget,
            ],
          ),
        ),
      );
    },
  );
}
