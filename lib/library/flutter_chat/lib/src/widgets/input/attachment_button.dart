import 'package:flutter/material.dart';

import '../state/inherited_chat_theme.dart';
import '../state/inherited_l10n.dart';

/// A class that represents attachment button widget.
class AttachmentButton extends StatelessWidget {
  /// Creates attachment button widget.
  const AttachmentButton({
    super.key,
    this.isLoading = false,
    this.onPressed,
    this.iconColor,
    this.padding = EdgeInsets.zero,
  });

  final Color? iconColor;

  /// Show a loading indicator instead of the button.
  final bool isLoading;

  /// Callback for attachment button tap event.
  final VoidCallback? onPressed;

  /// Padding around the button.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => IconButton(
        constraints: const BoxConstraints(
          minHeight: 20,
          minWidth: 20,
        ),
        icon: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    InheritedChatTheme.of(context).theme.inputTextColor,
                  ),
                ),
              )
            : InheritedChatTheme.of(context).theme.attachmentButtonIcon ??
                Image.asset(
                  'assets/icons/icon-attachment.png',
                  height: 24,
                  width: 24,
                  color: iconColor ?? InheritedChatTheme.of(context).theme.inputTextColor,
                ),
        onPressed: isLoading ? null : onPressed,
        padding: padding,
        splashRadius: 24,
        tooltip: InheritedL10n.of(context).l10n.attachmentButtonAccessibilityLabel,
      );
}
