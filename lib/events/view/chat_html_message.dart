import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/dracula.dart';
import 'package:flutter_highlighter/themes/vs.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:linkify/linkify.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/build_context_x.dart';
import '../../common/view/confirm.dart';
import '../../l10n/l10n.dart';
import '../../common/view/mxc_image.dart';

// Credit: this code has been initially copied from https://github.com/krille-chan/fluffychat
// Thank you @krille-chan
class HtmlMessage extends StatelessWidget {
  final String html;
  final Room room;
  final TextStyle? style;

  const HtmlMessage({
    super.key,
    required this.html,
    required this.room,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final fontSize = style?.fontSize ?? 12;
    final defaultTextColor = context.colorScheme.onSurface;
    final element = _linkifyHtml(HtmlParser.parseHTML(html));

    final theStyle = Style.fromTextStyle(style!).copyWith(
      padding: HtmlPaddings.zero,
      margin: Margins.zero,
    );
    return Html.fromElement(
      documentElement: element as dom.Element,
      style: style == null
          ? {}
          : {
              '*': theStyle,
              'code': theStyle,
              'pre': theStyle,
              'a': theStyle.copyWith(color: context.colorScheme.link),
            },
      extensions: [
        CodeExtension(fontSize: fontSize, isLight: theme.colorScheme.isLight),
        SpoilerExtension(textColor: defaultTextColor),
        const ImageExtension(),
        FontColorExtension(),
        FallbackTextExtension(style: style),
      ],
      onLinkTap: (url, attributes, element) {
        if (url != null && Uri.tryParse(url) != null) {
          showDialog(
            context: context,
            builder: (context) => ConfirmationDialog(
              title: Text(
                '${context.l10n.openLinkInBrowser}?',
              ),
              content: SizedBox(
                width: 400,
                child: Text(url),
              ),
              onConfirm: () => launchUrl(Uri.parse(url)),
            ),
          );
        }
      },
      onlyRenderTheseTags: const {
        ..._allowedHtmlTags,
        'body',
        'html',
      },
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
          {
            colorAttribute,
            mxColorAttribute,
            bgColorAttribute,
          }.contains,
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
  InlineSpan build(
    ExtensionContext context,
  ) {
    final colorText = context.element?.attributes[colorAttribute] ??
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

  const ImageExtension({this.defaultDimension = 64});

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
        child: MxcImage(
          uri: mxcUrl,
          width: actualWidth,
          height: actualHeight,
          // isThumbnail: (actualWidth * actualHeight) > (256 * 256),
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

  CodeExtension({
    required this.fontSize,
    required this.isLight,
  });
  @override
  Set<String> get supportedTags => {'code', 'pre'};

  @override
  InlineSpan build(ExtensionContext context) => WidgetSpan(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: HighlightView(
            padding: EdgeInsets.zero,
            context.element?.text ?? '',
            language: context.element?.className
                    .split(' ')
                    .singleWhereOrNull(
                      (c) => c.startsWith('language-'),
                    )
                    ?.split('language-')
                    .last ??
                'md',
            theme: isLight ? vsTheme : draculaTheme,
            textStyle: TextStyle(
              fontSize: fontSize,
              fontFamily: 'UbuntuMono',
            ),
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
  InlineSpan build(ExtensionContext context) => TextSpan(
        text: context.element?.text ?? '',
        style: style,
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
