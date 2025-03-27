import 'package:chatify_ai/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class BuildTileWigets extends StatelessWidget {
  final IconData? icon;
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
        color: Theme.of(context).iconTheme.color,
        size: 20,
      ),
      title: Text(title, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color, fontSize: 15)),
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
  const CustomSwitchButtonWigets({super.key, this.onClick, required this.isSwitched});

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
          color: isSwitched ? Theme.of(context).primaryColor : Colors.grey.shade300,
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

class GetPrimeWigets extends StatelessWidget {
  const GetPrimeWigets({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.upgrade);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.6),
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ]),
        ),
        child: Row(
          children: [
            Icon(
              HugeIcons.strokeRoundedCrown,
              color: Colors.white,
              size: 18,
              fill: 1,
            ),
            SizedBox(width: 8),
            Text(
              'GET PRIMEUM',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
