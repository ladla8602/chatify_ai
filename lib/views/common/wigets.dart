import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart';

class BuildTileWigets extends StatelessWidget {
  final IconData ? icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  const BuildTileWigets({
    super.key,
     this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Icon(
        icon,
        color: Colors.black,
        size: 20,
      ),
      title: Text(title,
          style: const TextStyle(color: Colors.black, fontSize: 15)),
      trailing: trailing ??
          const Icon(
            HugeIcons.strokeRoundedArrowRight01,
            size: 20,
          ),
      onTap: onTap,
    );
  }
}

class CustomSwitchButtonWigets extends StatelessWidget {
  final bool isSwitched;
  final VoidCallback? onClick;
  const CustomSwitchButtonWigets(
      {super.key, this.onClick, required this.isSwitched});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isSwitched ? Colors.green : Colors.grey.shade300,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              left: isSwitched ? 20 : 0,
              right: isSwitched ? 0 : 20,
              child: Container(
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
