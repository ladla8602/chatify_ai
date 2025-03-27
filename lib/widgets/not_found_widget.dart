import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotFoundWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onButtonClick;
  const NotFoundWidget({super.key, this.title = 'Empty', this.subtitle = '', this.buttonText = 'Retry', this.onButtonClick});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.10),
          SvgPicture.asset(
            "assets/icons/empty.svg",
            width: 150,
            colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
          ),
          const SizedBox(height: 36),
          Text(
            title,
            style: TextStyle(fontSize: 22, color: Theme.of(context).primaryColor),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: const TextStyle(fontSize: 16),
            ),
          const SizedBox(height: 8),
          if (onButtonClick != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(31))),
              onPressed: onButtonClick,
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
