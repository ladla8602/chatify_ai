import 'package:chatify_ai/widgets/fade_shimmer.dart';
import 'package:flutter/material.dart';

class ChatHistoryLoadingEffect extends StatelessWidget {
  const ChatHistoryLoadingEffect({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: 8,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.only(top: 10, left: 0, right: 10, bottom: 10),
          width: MediaQuery.of(context).size.width,
          height: 85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            children: [
              Container(
                width: 5,
                height: 14,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: FadeShimmer(
                        height: 18,
                        width: width * 0.5,
                        radius: 4,
                        fadeTheme: Theme.of(context).brightness == Brightness.dark ? FadeTheme.dark : FadeTheme.light,
                        highlightColor: Theme.of(context).colorScheme.surface,
                        baseColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Flexible(
                      child: FadeShimmer(
                        height: 12,
                        width: width * 0.5,
                        radius: 4,
                        fadeTheme: Theme.of(context).brightness == Brightness.dark ? FadeTheme.dark : FadeTheme.light,
                        highlightColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                        baseColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Flexible(
                      child: FadeShimmer(
                        height: 12,
                        width: width * 0.5,
                        radius: 4,
                        fadeTheme: Theme.of(context).brightness == Brightness.dark ? FadeTheme.dark : FadeTheme.light,
                        highlightColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                        baseColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FadeShimmer.round(
                      size: 50,
                      fadeTheme: Theme.of(context).brightness == Brightness.dark ? FadeTheme.dark : FadeTheme.light,
                    ),
                    const SizedBox(height: 2),
                    Flexible(
                      child: FadeShimmer(
                        height: 18,
                        width: width * 0.5,
                        radius: 4,
                        fadeTheme: Theme.of(context).brightness == Brightness.dark ? FadeTheme.dark : FadeTheme.light,
                        highlightColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                        baseColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
