import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Link extends StatefulWidget {
  const Link({
    required this.text,
    required this.link,
    this.tooltip,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    Key? key,
  }) : super(key: key);

  final TextStyle? style;
  final String link;
  final String text;
  final String? tooltip;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  @override
  State<Link> createState() => _LinkState();
}

class _LinkState extends State<Link> {
  final controller = ValueNotifier<bool>(false);
  final cursorController = ValueNotifier<MouseCursor>(SystemMouseCursors.click);
  final node = FocusNode();
  final key = GlobalKey<State<Tooltip>>();

  void listener() {
    if (node.hasPrimaryFocus) {
      final dynamic tooltipState = key.currentState;
      // ignore: avoid_dynamic_calls
      tooltipState?.ensureTooltipVisible();
      controller.value = true;
    } else if (!node.hasFocus) {
      key.currentState?.deactivate();
      controller.value = false;
    }
  }

  @override
  void initState() {
    node.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    node.removeListener(listener);
    cursorController.dispose();
    controller.dispose();
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? DefaultTextStyle.of(context).style;
    return Semantics(
      button: true,
      focusable: true,
      focused: node.hasFocus,
      hint: widget.tooltip,
      link: true,
      label: widget.semanticsLabel,
      child: MergeSemantics(
        child: Focus(
          focusNode: node,
          child: GestureDetector(
            onTap: () async {
              cursorController.value = SystemMouseCursors.grabbing;
              await launch(
                widget.link,
                forceWebView: true,
                enableJavaScript: true,
              );
              cursorController.value = SystemMouseCursors.click;
            },
            onLongPressDown: (_) {
              cursorController.value = SystemMouseCursors.grabbing;
              node.requestFocus();
            },
            onLongPressUp: () {
              if (node.hasFocus) node.unfocus();
              cursorController.value = SystemMouseCursors.click;
            },
            child: ValueListenableBuilder<MouseCursor>(
              valueListenable: cursorController,
              builder: (context, cursor, child) {
                return MouseRegion(
                  cursor: cursor,
                  onEnter: (_) {
                    cursorController.value = SystemMouseCursors.click;
                    node.requestFocus();
                  },
                  onExit: (_) {
                    if (node.hasFocus) node.unfocus();
                  },
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ValueListenableBuilder<bool>(
                  valueListenable: controller,
                  builder: (context, hovering, _) {
                    final decoratedStyle = style.apply(
                      decoration: hovering ? TextDecoration.underline : null,
                    );
                    return Tooltip(
                      key: key,
                      message: widget.tooltip,
                      triggerMode: TooltipTriggerMode.manual,
                      child: Text(
                        widget.text,
                        style: decoratedStyle,
                        locale: widget.locale,
                        maxLines: widget.maxLines,
                        overflow: widget.overflow,
                        softWrap: widget.softWrap,
                        strutStyle: widget.strutStyle,
                        textAlign: widget.textAlign,
                        textDirection: widget.textDirection,
                        textHeightBehavior: widget.textHeightBehavior,
                        textScaleFactor: widget.textScaleFactor,
                        textWidthBasis: widget.textWidthBasis,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
