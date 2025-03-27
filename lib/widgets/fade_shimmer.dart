import 'dart:async';

import 'package:flutter/material.dart';

enum FadeTheme { light, dark }

class FadeShimmer extends StatefulWidget {
  final Color? highlightColor;
  final Color? baseColor;
  final double radius;
  final double width;
  final double height;

  /// light or dark with predefined highlightColor and baseColor
  /// need to pass this or highlightColor and baseColor
  final FadeTheme? fadeTheme;

  /// delay time before update the color, use this to make loading items animate follow each other instead of parallel, check the example for demo.
  final int millisecondsDelay;

  const FadeShimmer(
      {super.key, this.millisecondsDelay = 0, this.radius = 0, this.fadeTheme, this.highlightColor, this.baseColor, required this.width, required this.height})
      : assert((highlightColor != null && baseColor != null) || fadeTheme != null);

  /// use this to create a round loading widget
  factory FadeShimmer.round({required double size, Color? highlightColor, int millisecondsDelay = 0, Color? baseColor, FadeTheme? fadeTheme}) => FadeShimmer(
        height: size,
        width: size,
        radius: size / 2,
        baseColor: baseColor,
        highlightColor: highlightColor,
        fadeTheme: fadeTheme,
        millisecondsDelay: millisecondsDelay,
      );

  @override
  _FadeShimmerState createState() => _FadeShimmerState();
}

class _FadeShimmerState extends State<FadeShimmer> {
  static final isHighLightStream = Stream<bool>.periodic(const Duration(seconds: 1), (x) => x % 2 == 0).asBroadcastStream();
  bool isHighLight = true;
  late StreamSubscription sub;

  Color get highLightColor {
    if (widget.fadeTheme != null) {
      switch (widget.fadeTheme) {
        case FadeTheme.light:
          return const Color(0xffF9F9FB);
        case FadeTheme.dark:
          return const Color(0xff3A3E3F);
        default:
          return const Color(0xff3A3E3F);
      }
    }
    return widget.highlightColor!;
  }

  Color get baseColor {
    if (widget.fadeTheme != null) {
      switch (widget.fadeTheme) {
        case FadeTheme.light:
          return const Color(0xffE6E8EB);
        case FadeTheme.dark:
          return const Color(0xff2A2C2E);
        default:
          return const Color(0xff2A2C2E);
      }
    }
    return widget.baseColor!;
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  void safeSetState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    sub = isHighLightStream.listen((isHighLight) {
      if (widget.millisecondsDelay != 0) {
        Future.delayed(Duration(milliseconds: widget.millisecondsDelay), () {
          isHighLight = isHighLight;
          safeSetState();
        });
      } else {
        isHighLight = isHighLight;
        safeSetState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 1200),
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(color: isHighLight ? highLightColor : baseColor, borderRadius: BorderRadius.circular(widget.radius)),
    );
  }
}
