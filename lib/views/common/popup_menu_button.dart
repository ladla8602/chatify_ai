import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ThemedPopupMenuButton extends StatelessWidget {
  final void Function(String)? onSelected;
  final String ? text;

  const ThemedPopupMenuButton({
    super.key,
    this.onSelected,
   this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: const PopupMenuThemeData(
          color: Colors.white, // Background color of the menu
          textStyle: TextStyle(color: Colors.black),
        ),
      ),
      child: PopupMenuButton<String>(
        icon: const Icon(
          HugeIcons.strokeRoundedMoreVertical, // HugeIcons preserved
          color: Colors.black, // Set icon color
        ),
        onSelected: onSelected,
        itemBuilder: (context) => [
          const PopupMenuItem<String>(
            value: 'Share Link',
            child: ListTile(
              leading: Icon(HugeIcons.strokeRoundedShare01,
                  size: 20, color: Colors.black),
              title: Text('Share Link'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'Unpin',
            child: ListTile(
              leading: Icon(HugeIcons.strokeRoundedPinOff, size: 20, color: Colors.black),
              title: Text('Unpin'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'Rename',
            child: ListTile(
              leading: Icon(HugeIcons.strokeRoundedEdit01, size: 20, color: Colors.black),
              title: Text('Rename'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'Delete',
            child: ListTile(
              leading: Icon(HugeIcons.strokeRoundedDelete01, size: 20, color: Colors.red),
              title: Text('Delete', style: TextStyle(color: Colors.red),),
            ),
          ),
        ],
      ),
    );
  }
}
