import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Link extends StatefulWidget {
  const Link({
    Key? key,
    this.style,
    required this.text,
    required this.link,
  }) : super(key: key);

  final TextStyle? style;
  final String link;
  final String text;

  @override
  State<Link> createState() => _LinkState();
}

class _LinkState extends State<Link> {
  final controller = ValueNotifier<bool>(false);
  final cursorController = ValueNotifier<MouseCursor>(SystemMouseCursors.click);
  final node = FocusNode();

  void listener() {
    if (node.hasPrimaryFocus) {
      controller.value = true;
    } else if (!node.hasFocus) {
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
    controller.dispose();
    cursorController.dispose();
    node.removeListener(listener);
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Focus(
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
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<bool>(
              valueListenable: controller,
              builder: (context, hovering, _) {
                return Text(
                  widget.text,
                  style: (widget.style ?? theme.textTheme.bodyText2)?.apply(
                    decoration: hovering ? TextDecoration.underline : null,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
