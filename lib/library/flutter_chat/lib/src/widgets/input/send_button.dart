import 'package:flutter/material.dart';
import '../state/inherited_l10n.dart';

/// A class that represents send button widget.
class SendButton extends StatelessWidget {
  /// Creates send button widget.
  const SendButton({
    super.key,
    required this.onPressed,
    this.iconColor,
    this.icon,
    this.padding = EdgeInsets.zero,
  });

  final Color? iconColor;
  final IconData? icon;

  /// Callback for send button tap event.
  final VoidCallback? onPressed;

  /// Padding around the button.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Center(
        child: Semantics(
          label: InheritedL10n.of(context).l10n.sendButtonAccessibilityLabel,
          child: IconButton(
            enableFeedback: true,
            icon: Icon(
              icon ?? Icons.send,
              size: 22,
              color: Colors.white,
            ),
            onPressed: onPressed,
            padding: padding,
            splashRadius: 24,
            disabledColor: Theme.of(context).colorScheme.outline,
            color: Theme.of(context).primaryColor,
            tooltip: InheritedL10n.of(context).l10n.sendButtonAccessibilityLabel,
          ),
        ),
      );
}
