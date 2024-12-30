import 'package:flutter/material.dart';

import 'animated_text.dart';
import 'typewriter.dart';

class TypingLoaderWidget extends StatelessWidget {
  final String title;
  const TypingLoaderWidget({super.key, this.title = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          title,
          textAlign: TextAlign.center,
          speed: const Duration(milliseconds: 100),
        ),
      ],
      totalRepeatCount: 2,
      stopPauseOnTap: false,
    );
  }
}
