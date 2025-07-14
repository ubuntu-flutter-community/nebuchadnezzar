import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../common/view/build_context_x.dart';
import '../../common/event_x.dart';

class LocalizedDisplayEventText extends StatefulWidget {
  const LocalizedDisplayEventText({
    super.key,
    required this.displayEvent,
    this.style,
    this.textAlign,
  });

  final Event displayEvent;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  State<LocalizedDisplayEventText> createState() =>
      _LocalizedDisplayEventTextState();
}

class _LocalizedDisplayEventTextState extends State<LocalizedDisplayEventText> {
  late final Future<String> _future;
  static final Map<String, String> _cache = {};

  @override
  void initState() {
    super.initState();
    _future = widget.displayEvent.calcLocalizedBody(
      const MatrixDefaultLocalizations(),
    );
  }

  @override
  Widget build(BuildContext context) =>
      _cache.containsKey(widget.displayEvent.eventId)
      ? _Content(
          text: _cache[widget.displayEvent.eventId]!,
          style: widget.style,
          textAlign: widget.textAlign,
          badge: widget.displayEvent.showAsBadge,
        )
      : FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _Content(
                text: snapshot.error.toString(),
                style: widget.style,
                textAlign: widget.textAlign,
                badge: widget.displayEvent.showAsBadge,
              );
            }
            if (snapshot.hasData) {
              _cache.update(
                widget.displayEvent.eventId,
                (_) => snapshot.data!,
                ifAbsent: () => snapshot.data!,
              );
            }

            return AnimatedOpacity(
              opacity: snapshot.hasData ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: _Content(
                text: snapshot.data ?? widget.displayEvent.body,
                style: widget.style,
                textAlign: widget.textAlign,
                badge: widget.displayEvent.showAsBadge,
              ),
            );
          },
        );
}

class _Content extends StatelessWidget {
  const _Content({
    required this.text,
    this.style,
    this.textAlign,
    this.badge = false,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    final theStyle = (style ?? context.textTheme.labelSmall)?.copyWith(
      overflow: TextOverflow.ellipsis,
    );
    final align = textAlign;

    if (badge) {
      return Text(text, textAlign: align, style: theStyle);
    }

    return SelectableText.rich(
      TextSpan(text: text),
      textAlign: align,
      style: theStyle,
    );
  }
}
