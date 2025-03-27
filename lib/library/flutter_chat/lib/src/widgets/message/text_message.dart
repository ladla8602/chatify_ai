import 'package:flutter/material.dart';
import '../../utils/link_preview.dart';
import '../../utils/util.dart';
import '../focused_menu.dart';
import './../../types/types.dart' as types;
import 'package:flutter_parsed_text/flutter_parsed_text.dart';

import '../../models/emoji_enlargement_behavior.dart';
import '../../models/matchers.dart';
import '../../models/pattern_style.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_user.dart';
import 'user_name.dart';

/// A class that represents text message widget with optional link preview.
class TextMessage extends StatelessWidget {
  /// Creates a text message widget from a [types.TextMessage] class.
  const TextMessage({
    super.key,
    required this.emojiEnlargementBehavior,
    required this.hideBackgroundOnEmojiMessages,
    required this.message,
    this.nameBuilder,
    this.onPreviewDataFetched,
    this.options = const TextMessageOptions(),
    required this.showName,
    required this.usePreviewData,
    this.userAgent,
    this.onRegeneratePressed,
    this.onCopyPressed,
    this.onSharePressed,
    this.onSelectPressed,
    this.canRegenerate = false,
  });

  /// See [Message.emojiEnlargementBehavior].
  final EmojiEnlargementBehavior emojiEnlargementBehavior;

  /// See [Message.hideBackgroundOnEmojiMessages].
  final bool hideBackgroundOnEmojiMessages;

  /// [types.TextMessage].
  final types.TextMessage message;

  /// This is to allow custom user name builder
  /// By using this we can fetch newest user info based on id.
  final Widget Function(types.User)? nameBuilder;

  /// See [LinkPreview.onPreviewDataFetched].
  final void Function(types.TextMessage, types.PreviewData)? onPreviewDataFetched;

  /// Customisation options for the [TextMessage].
  final TextMessageOptions options;

  /// Show user name for the received message. Useful for a group chat.
  final bool showName;

  /// Enables link (URL) preview.
  final bool usePreviewData;

  /// User agent to fetch preview data with.
  final String? userAgent;

  final Function()? onRegeneratePressed;
  final Function(types.PartialText)? onCopyPressed;
  final Function(types.PartialText)? onSharePressed;
  final Function(types.PartialText)? onSelectPressed;

  final bool canRegenerate;

  Widget _linkPreview(
    types.User user,
    double width,
    BuildContext context,
  ) {
    final linkDescriptionTextStyle = user.id == message.author.id
        ? InheritedChatTheme.of(context).theme.sentMessageLinkDescriptionTextStyle
        : InheritedChatTheme.of(context).theme.receivedMessageLinkDescriptionTextStyle;
    final linkTitleTextStyle = user.id == message.author.id
        ? InheritedChatTheme.of(context).theme.sentMessageLinkTitleTextStyle
        : InheritedChatTheme.of(context).theme.receivedMessageLinkTitleTextStyle;

    return LinkPreview(
      enableAnimation: true,
      metadataTextStyle: linkDescriptionTextStyle,
      metadataTitleStyle: linkTitleTextStyle,
      onLinkPressed: options.onLinkPressed,
      onPreviewDataFetched: _onPreviewDataFetched,
      openOnPreviewImageTap: options.openOnPreviewImageTap,
      openOnPreviewTitleTap: options.openOnPreviewTitleTap,
      padding: EdgeInsets.symmetric(
        horizontal: InheritedChatTheme.of(context).theme.messageInsetsHorizontal,
        vertical: InheritedChatTheme.of(context).theme.messageInsetsVertical,
      ),
      previewData: message.previewData,
      text: message.text,
      textWidget: _textWidgetBuilder(user, context, false),
      userAgent: userAgent,
      width: width,
    );
  }

  void _onPreviewDataFetched(types.PreviewData previewData) {
    if (message.previewData == null) {
      onPreviewDataFetched?.call(message, previewData);
    }
  }

  Widget _textWidgetBuilder(
    types.User user,
    BuildContext context,
    bool enlargeEmojis,
  ) {
    final theme = InheritedChatTheme.of(context).theme;
    final bodyLinkTextStyle = user.id == message.author.id
        ? InheritedChatTheme.of(context).theme.sentMessageBodyLinkTextStyle
        : InheritedChatTheme.of(context).theme.receivedMessageBodyLinkTextStyle;
    final bodyTextStyle = user.id == message.author.id ? theme.sentMessageBodyTextStyle : theme.receivedMessageBodyTextStyle;
    final boldTextStyle = user.id == message.author.id ? theme.sentMessageBodyBoldTextStyle : theme.receivedMessageBodyBoldTextStyle;
    final codeTextStyle = user.id == message.author.id ? theme.sentMessageBodyCodeTextStyle : theme.receivedMessageBodyCodeTextStyle;
    final emojiTextStyle = user.id == message.author.id ? theme.sentEmojiMessageTextStyle : theme.receivedEmojiMessageTextStyle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showName) nameBuilder?.call(message.author) ?? UserName(author: message.author),
        if (enlargeEmojis)
          if (options.isTextSelectable)
            TextFocusMethodHolderWidget(
              message: message,
              onRegeneratePressed: onRegeneratePressed,
              onCopyPressed: onCopyPressed,
              onSharePressed: onSharePressed,
              onSelectPressed: onSelectPressed,
              canRegenerate: canRegenerate,
              child: SelectableText(
                message.text,
                style: emojiTextStyle,
                enableInteractiveSelection: false,
              ),
            )
          else
            TextFocusMethodHolderWidget(
                message: message,
                onRegeneratePressed: onRegeneratePressed,
                canRegenerate: canRegenerate,
                onCopyPressed: onCopyPressed,
                onSharePressed: onSharePressed,
                onSelectPressed: onSelectPressed,
                child: Text(
                  message.text,
                  style: emojiTextStyle,
                ))
        else
          TextFocusMethodHolderWidget(
              message: message,
              onRegeneratePressed: onRegeneratePressed,
              canRegenerate: canRegenerate,
              onCopyPressed: onCopyPressed,
              onSharePressed: onSharePressed,
              onSelectPressed: onSelectPressed,
              child: TextMessageText(
                bodyLinkTextStyle: bodyLinkTextStyle,
                bodyTextStyle: bodyTextStyle,
                boldTextStyle: boldTextStyle,
                codeTextStyle: codeTextStyle,
                options: options,
                text: message.text,
              )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final enlargeEmojis = emojiEnlargementBehavior != EmojiEnlargementBehavior.never && isConsistsOfEmojis(emojiEnlargementBehavior, message);
    final theme = InheritedChatTheme.of(context).theme;
    final user = InheritedUser.of(context).user;
    final width = MediaQuery.of(context).size.width;

    if (usePreviewData && onPreviewDataFetched != null) {
      final urlRegexp = RegExp(regexLink, caseSensitive: false);
      final matches = urlRegexp.allMatches(message.text);

      if (matches.isNotEmpty) {
        return _linkPreview(user, width, context);
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: theme.messageInsetsHorizontal,
        vertical: theme.messageInsetsVertical,
      ),
      child: _textWidgetBuilder(user, context, enlargeEmojis),
    );
  }
}

// ignore: must_be_immutable
class TextFocusMethodHolderWidget extends StatelessWidget {
  TextFocusMethodHolderWidget(
      {super.key,
      required this.message,
      required this.child,
      this.onRegeneratePressed,
      this.onCopyPressed,
      this.onSharePressed,
      this.onSelectPressed,
      this.canRegenerate = false});

  final Widget child;
  final Function()? onRegeneratePressed;
  final Function(types.PartialText)? onCopyPressed;
  final Function(types.PartialText)? onSharePressed;
  final Function(types.PartialText)? onSelectPressed;
  types.TextMessage message;
  bool canRegenerate;
  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      menuWidth: MediaQuery.of(context).size.width * 0.50,
      blurSize: 0.5,
      menuItemExtent: 45,
      menuBoxDecoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18.0))),
      duration: const Duration(milliseconds: 100),
      animateMenuItems: true,
      blurBackgroundColor: Colors.black12,
      widthBorder: 0,
      borderColor: Theme.of(context).colorScheme.surface,
      openWithTap: false, // Open Focused-Menu on Tap rather than Long Press
      menuItems: <FocusedMenuItem>[
        if (canRegenerate)
          FocusedMenuItem(
            title: const Text("Regenerate"),
            trailingIcon: const Icon(Icons.refresh),
            backgroundColor: Theme.of(context).colorScheme.surface,
            onPressed: onRegeneratePressed,
          ),
        FocusedMenuItem(
          title: const Text("Copy"),
          trailingIcon: const Icon(Icons.copy),
          backgroundColor: Theme.of(context).colorScheme.surface,
          onPressed: () {
            onCopyPressed!(types.PartialText(text: message.text));
          },
        ),
        FocusedMenuItem(
            title: const Text("Select Text"),
            trailingIcon: const Icon(Icons.select_all),
            backgroundColor: Theme.of(context).colorScheme.surface,
            onPressed: () {
              onSelectPressed!(types.PartialText(text: message.text));
            }),
        FocusedMenuItem(
          title: const Text("Share"),
          trailingIcon: const Icon(Icons.share),
          backgroundColor: Theme.of(context).colorScheme.surface,
          onPressed: () {
            onSharePressed!(types.PartialText(text: message.text));
          },
        ),
        // FocusedMenuItem(
        //   title: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
        //   trailingIcon: const Icon(TablerIcons.trash, color: Colors.redAccent),
        //   backgroundColor: Theme.of(context).colorScheme.surface,
        //   onPressed: () {},
        // ),
      ],
      onPressed: () {},
      child: child,
    );
  }
}

/// Widget to reuse the markdown capabilities, e.g., for previews.
class TextMessageText extends StatelessWidget {
  const TextMessageText({
    super.key,
    this.bodyLinkTextStyle,
    required this.bodyTextStyle,
    this.boldTextStyle,
    this.codeTextStyle,
    this.maxLines,
    this.options = const TextMessageOptions(),
    this.overflow = TextOverflow.clip,
    required this.text,
  });

  /// Style to apply to anything that matches a link.
  final TextStyle? bodyLinkTextStyle;

  /// Regular style to use for any unmatched text. Also used as basis for the fallback options.
  final TextStyle bodyTextStyle;

  /// Style to apply to anything that matches bold markdown.
  final TextStyle? boldTextStyle;

  /// Style to apply to anything that matches code markdown.
  final TextStyle? codeTextStyle;

  /// See [ParsedText.maxLines].
  final int? maxLines;

  /// See [TextMessage.options].
  final TextMessageOptions options;

  /// See [ParsedText.overflow].
  final TextOverflow overflow;

  /// Text that is shown as markdown.
  final String text;

  @override
  Widget build(BuildContext context) => ParsedText(
        parse: [
          ...options.matchers,
          mailToMatcher(
            style: bodyLinkTextStyle ??
                bodyTextStyle.copyWith(
                  decoration: TextDecoration.underline,
                ),
          ),
          urlMatcher(
            onLinkPressed: options.onLinkPressed,
            style: bodyLinkTextStyle ??
                bodyTextStyle.copyWith(
                  decoration: TextDecoration.underline,
                ),
          ),
          boldMatcher(
            style: boldTextStyle ?? bodyTextStyle.merge(PatternStyle.bold.textStyle),
          ),
          italicMatcher(
            style: bodyTextStyle.merge(PatternStyle.italic.textStyle),
          ),
          lineThroughMatcher(
            style: bodyTextStyle.merge(PatternStyle.lineThrough.textStyle),
          ),
          codeMatcher(
            style: codeTextStyle ?? bodyTextStyle.merge(PatternStyle.code.textStyle),
          ),
        ],
        maxLines: maxLines,
        overflow: overflow,
        regexOptions: const RegexOptions(multiLine: true, dotAll: true),
        selectable: options.isTextSelectable,
        style: bodyTextStyle,
        text: text,
        textWidthBasis: TextWidthBasis.longestLine,
      );
}

@immutable
class TextMessageOptions {
  const TextMessageOptions({
    this.isTextSelectable = false,
    this.onLinkPressed,
    this.openOnPreviewImageTap = false,
    this.openOnPreviewTitleTap = false,
    this.matchers = const [],
  });

  /// Whether user can tap and hold to select a text content.
  final bool isTextSelectable;

  /// Custom link press handler.
  final void Function(String)? onLinkPressed;

  /// See [LinkPreview.openOnPreviewImageTap].
  final bool openOnPreviewImageTap;

  /// See [LinkPreview.openOnPreviewTitleTap].
  final bool openOnPreviewTitleTap;

  /// Additional matchers to parse the text.
  final List<MatchText> matchers;
}
