import 'package:chatify_ai/widgets/fade_shimmer.dart';
import 'package:flutter/material.dart';

class ChatBotLoadingEffect extends StatelessWidget {
  const ChatBotLoadingEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Column(
              children: [
                FadeShimmer.round(
                  size: 60,
                  fadeTheme: Theme.of(context).brightness == Brightness.dark ? FadeTheme.dark : FadeTheme.light,
                ),
                const SizedBox(height: 4),
                FadeShimmer(
                  height: 8,
                  width: 70,
                  radius: 4,
                  fadeTheme: Theme.of(context).brightness == Brightness.dark ? FadeTheme.dark : FadeTheme.light,
                  highlightColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                  baseColor: Theme.of(context).colorScheme.surface,
                ),
                const SizedBox(height: 4),
                FadeShimmer(
                  height: 8,
                  width: 80,
                  radius: 4,
                  fadeTheme: Theme.of(context).brightness == Brightness.dark ? FadeTheme.dark : FadeTheme.light,
                  highlightColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                  baseColor: Theme.of(context).colorScheme.surface,
                ),
              ],
            );
          },
          separatorBuilder: (context, id) => const SizedBox(width: 8),
          itemCount: 12),
    );
  }
}
