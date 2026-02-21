import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/dracula.dart';
import 'package:flutter_highlighter/themes/vs.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:linkify/linkify.dart';
import 'package:matrix/matrix.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/safe_network_image.dart';
import '../../common/view/ui_constants.dart';
import '../../extensions/event_x.dart';
import 'chat_html_message_link_handler.dart';
import 'chat_image.dart';

// Credit: this code has been initially copied from https://github.com/krille-chan/fluffychat
// Thank you @krille-chan
class HtmlMessage extends StatelessWidget {
  final Event displayEvent;
  final TextStyle? style;

  const HtmlMessage({
    super.key,
    required this.displayEvent,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final fontSize = style?.fontSize ?? 12;
    final colorScheme = context.colorScheme;
    final defaultTextColor = colorScheme.onSurface;
    final element = _linkifyHtml(
      HtmlParser.parseHTML(displayEvent.formattedText),
    );

    final theStyle = (style == null ? Style() : Style.fromTextStyle(style!))
        .copyWith(padding: HtmlPaddings.zero, margin: Margins.zero);
    return Html.fromElement(
      documentElement: element as dom.Element,
      style: style == null
          ? {}
          : {
              '*': theStyle,
              'code': theStyle,
              'pre': theStyle,
              'a': theStyle.copyWith(
                color: displayEvent.isUserEvent
                    ? colorScheme.primary.scale(
                        lightness: theme.colorScheme.isLight ? -0.5 : 0.4,
                        saturation: 1,
                      )
                    : colorScheme.link,
              ),
            },
      extensions: [
        CodeExtension(fontSize: fontSize, isLight: theme.colorScheme.isLight),
        SpoilerExtension(textColor: defaultTextColor),
        ImageExtension(displayEvent),
        FontColorExtension(),
        FallbackTextExtension(style: style),
        YouTubeLinkPreviewExtension(),
      ],
      onLinkTap: (url, attributes, element) =>
          chatHtmlMessageLinkHandler(url, attributes, element, context),
      onlyRenderTheseTags: const {..._allowedHtmlTags, 'body', 'html'},
      shrinkWrap: true,
    );
  }

  dom.Node _linkifyHtml(dom.Node element) {
    for (final node in element.nodes) {
      if (node is! dom.Text ||
          (element is dom.Element && element.localName == 'code')) {
        node.replaceWith(_linkifyHtml(node));
        continue;
      }

      final parts = linkify(
        node.text,
        options: const LinkifyOptions(humanize: false),
      );

      if (!parts.any((part) => part is UrlElement)) {
        continue;
      }

      final newHtml = parts
          .map(
            (linkifyElement) => linkifyElement is! UrlElement
                ? linkifyElement.text.replaceAll('<', '&#60;')
                : '<a href="${linkifyElement.text}">${linkifyElement.text}</a>',
          )
          .join(' ');

      node.replaceWith(dom.Element.html('<p>$newHtml</p>'));
    }
    return element;
  }
}

class FontColorExtension extends HtmlExtension {
  static const String colorAttribute = 'color';
  static const String mxColorAttribute = 'data-mx-color';
  static const String bgColorAttribute = 'data-mx-bg-color';

  @override
  Set<String> get supportedTags => {'font', 'span'};

  @override
  bool matches(ExtensionContext context) {
    if (!supportedTags.contains(context.elementName)) return false;
    return context.element?.attributes.keys.any(
          {colorAttribute, mxColorAttribute, bgColorAttribute}.contains,
        ) ??
        false;
  }

  Color? hexToColor(String? hexCode) {
    if (hexCode == null) return null;
    if (hexCode.startsWith('#')) hexCode = hexCode.substring(1);
    if (hexCode.length == 6) hexCode = 'FF$hexCode';
    final colorValue = int.tryParse(hexCode, radix: 16);
    return colorValue == null ? null : Color(colorValue);
  }

  @override
  InlineSpan build(ExtensionContext context) {
    final colorText =
        context.element?.attributes[colorAttribute] ??
        context.element?.attributes[mxColorAttribute];
    final bgColor = context.element?.attributes[bgColorAttribute];
    return TextSpan(
      style: TextStyle(
        color: hexToColor(colorText),
        backgroundColor: hexToColor(bgColor),
      ),
      text: context.innerHtml,
    );
  }
}

class ImageExtension extends HtmlExtension {
  final double defaultDimension;
  final Event event;

  const ImageExtension(this.event, {this.defaultDimension = 64});

  @override
  Set<String> get supportedTags => {'img'};

  @override
  InlineSpan build(ExtensionContext context) {
    final mxcUrl = Uri.tryParse(context.attributes['src'] ?? '');
    if (mxcUrl == null || mxcUrl.scheme != 'mxc') {
      return TextSpan(text: context.attributes['alt']);
    }

    final width = double.tryParse(context.attributes['width'] ?? '');
    final height = double.tryParse(context.attributes['height'] ?? '');

    final actualWidth = width ?? height ?? defaultDimension;
    final actualHeight = height ?? width ?? defaultDimension;

    return WidgetSpan(
      child: SizedBox(
        width: actualWidth,
        height: actualHeight,
        child: ChatImage(
          event: event,
          width: actualWidth,
          height: actualHeight,
        ),
      ),
    );
  }
}

class SpoilerExtension extends HtmlExtension {
  final Color textColor;

  const SpoilerExtension({required this.textColor});

  @override
  Set<String> get supportedTags => {'span'};

  static const String customDataAttribute = 'data-mx-spoiler';

  @override
  bool matches(ExtensionContext context) {
    if (context.elementName != 'span') return false;
    return context.element?.attributes.containsKey(customDataAttribute) ??
        false;
  }

  @override
  InlineSpan build(ExtensionContext context) {
    var obscure = true;
    final children = context.inlineSpanChildren;
    return WidgetSpan(
      child: StatefulBuilder(
        builder: (context, setState) {
          return InkWell(
            onTap: () => setState(() {
              obscure = !obscure;
            }),
            child: RichText(
              text: TextSpan(
                style: obscure ? TextStyle(backgroundColor: textColor) : null,
                children: children,
              ),
            ),
          );
        },
      ),
    );
  }
}

class CodeExtension extends HtmlExtension {
  final double fontSize;
  final bool isLight;

  CodeExtension({required this.fontSize, required this.isLight});
  @override
  Set<String> get supportedTags => {'code', 'pre'};

  @override
  InlineSpan build(ExtensionContext context) => WidgetSpan(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: HighlightView(
        padding: EdgeInsets.zero,
        context.element?.text ?? '',
        language:
            context.element?.className
                .split(' ')
                .singleWhereOrNull((c) => c.startsWith('language-'))
                ?.split('language-')
                .last ??
            'md',
        theme: isLight ? vsTheme : draculaTheme,
        textStyle: TextStyle(fontSize: fontSize, fontFamily: 'UbuntuMono'),
      ),
    ),
  );
}

class FallbackTextExtension extends HtmlExtension {
  final TextStyle? style;

  FallbackTextExtension({required this.style});
  @override
  Set<String> get supportedTags => _fallbackTextTags;

  @override
  InlineSpan build(ExtensionContext context) =>
      TextSpan(text: context.element?.text ?? '', style: style);
}

class YouTubeLinkPreviewExtension extends HtmlExtension {
  @override
  Set<String> get supportedTags => {'a'};

  @override
  bool matches(ExtensionContext context) {
    if (context.elementName != 'a') return false;
    final href = context.attributes['href'] ?? '';
    return href.contains('youtube.com') || href.contains('youtu.be');
  }

  @override
  InlineSpan build(ExtensionContext context) => WidgetSpan(
    child: ChatYouTubeLinkPreview(url: context.attributes['href'] ?? ''),
  );
}

class ChatYouTubeLinkPreview extends StatelessWidget {
  final String url;

  const ChatYouTubeLinkPreview({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final thumbail = _getYoutubeThumbnails(url)?['high'];
    if (thumbail == null) return const SizedBox.shrink();

    return InkWell(
      onTap: () => chatHtmlMessageLinkHandler(url, {}, null, context),
      child: Column(
        mainAxisSize: .min,
        children: [
          const SizedBox(height: kSmallPadding),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: SafeNetworkImage(url: thumbail, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: kSmallPadding),
          YouTubeTitle(url: url),
        ],
      ),
    );
  }

  Map<String, String>? _getYoutubeThumbnails(String url) {
    final RegExp regExp = RegExp(
      r'^.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/|shorts\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
      caseSensitive: false,
      multiLine: false,
    );

    final Match? match = regExp.firstMatch(url);

    if (match != null && match.group(1)?.length == 11) {
      String videoId = match.group(1)!;
      String baseUrl = 'https://img.youtube.com/vi/$videoId';

      return {
        'max': '$baseUrl/maxresdefault.jpg',
        'high': '$baseUrl/hqdefault.jpg',
        'medium': '$baseUrl/mqdefault.jpg',
        'standard': '$baseUrl/sddefault.jpg',
        'default': '$baseUrl/default.jpg',
      };
    }

    return null;
  }
}

class YouTubeTitle extends StatefulWidget {
  const YouTubeTitle({super.key, required this.url});

  final String url;

  @override
  State<YouTubeTitle> createState() => _YouTubeTitleState();
}

class _YouTubeTitleState extends State<YouTubeTitle> {
  late final Future<String> future;
  static final Map<String, String> _titleCache = {};

  @override
  void initState() {
    super.initState();
    future = _titleCache[widget.url] != null
        ? Future.value(_titleCache[widget.url])
        : _getYoutubeTitle(widget.url).then((title) {
            _titleCache[widget.url] = title;
            return title;
          });
  }

  @override
  Widget build(BuildContext context) => _titleCache.containsKey(widget.url)
      ? _Title(title: 'YouTube: ${_titleCache[widget.url]}')
      : FutureBuilder(
          future: future,
          builder: (context, snapshot) => switch ((
            snapshot.connectionState,
            snapshot.data,
            snapshot.error,
          )) {
            (ConnectionState.done, String title?, _) => _Title(
              title: 'YouTube: $title',
            ),
            (ConnectionState.done, _, Object _?) => _Title(title: widget.url),
            _ => const SizedBox.shrink(),
          },
        );

  Future<String> _getYoutubeTitle(String url) async {
    try {
      final String oEmbedUrl =
          'https://www.youtube.com/oembed?url=$url&format=json';

      final response = await http.get(Uri.parse(oEmbedUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return (data['title'] as String?) ?? url;
      } else {
        return url;
      }
    } catch (e) {
      return url;
    }
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.center,
    style: context.textTheme.bodyMedium?.copyWith(
      color: context.colorScheme.primary,
      decoration: TextDecoration.underline,
    ),
  );
}

const Set<String> _fallbackTextTags = {'tg-forward'};

/// Keep in sync with: https://spec.matrix.org/v1.6/client-server-api/#mroommessage-msgtypes
const Set<String> _allowedHtmlTags = {
  'font',
  'del',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'blockquote',
  'p',
  'a',
  'ul',
  'ol',
  'sup',
  'sub',
  'li',
  'b',
  'i',
  'u',
  'strong',
  'em',
  'strike',
  'code',
  'hr',
  'br',
  'div',
  'table',
  'thead',
  'tbody',
  'tr',
  'th',
  'td',
  'caption',
  'pre',
  'span',
  'img',
  'details',
  'summary',
  // Not in the allowlist of the matrix spec yet but should be harmless:
  'ruby',
  'rp',
  'rt',
  ..._fallbackTextTags,
};
