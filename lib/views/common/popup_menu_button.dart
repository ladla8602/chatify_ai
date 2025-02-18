import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ThemedPopupMenuButton extends StatelessWidget {
  final void Function(String)? onSelected;
  final String? text;

  const ThemedPopupMenuButton({
    super.key,
    this.onSelected,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: Theme.of(context)
              .scaffoldBackgroundColor, // Background color of the menu
          textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      child: PopupMenuButton<String>(
        icon: Icon(
          HugeIcons.strokeRoundedMoreVertical, // HugeIcons preserved
          color: Theme.of(context).colorScheme.onSurface, // Set icon color
        ),
        onSelected: onSelected,
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'Share Link',
            child: ListTile(
              leading: Icon(HugeIcons.strokeRoundedShare01,
                  size: 20, color: Theme.of(context).colorScheme.onSurface),
              title: Text('Share Link'),
            ),
          ),
          PopupMenuItem<String>(
            value: 'Unpin',
            child: ListTile(
              leading: Icon(HugeIcons.strokeRoundedPinOff,
                  size: 20, color: Theme.of(context).colorScheme.onSurface),
              title: Text('Unpin'),
            ),
          ),
          PopupMenuItem<String>(
            value: 'Rename',
            child: ListTile(
              leading: Icon(HugeIcons.strokeRoundedEdit01,
                  size: 20, color: Theme.of(context).colorScheme.onSurface),
              title: Text('Rename'),
            ),
          ),
          PopupMenuItem<String>(
            value: 'Delete',
            child: ListTile(
              leading: Icon(HugeIcons.strokeRoundedDelete01,
                  size: 20, color: Colors.red),
              title: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
