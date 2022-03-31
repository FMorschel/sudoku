import 'dart:async';

import 'package:flutter/material.dart';

class NeumorphismButton extends StatefulWidget {
  const NeumorphismButton({
    Key? key,
    this.child = const SizedBox.shrink(),
    this.onTap,
    this.border,
    this.selectedColor,
    this.isSelected = false,
  }) : super(key: key);

  final Widget child;
  final bool isSelected;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final Color? selectedColor;

  @override
  State<NeumorphismButton> createState() => _NeumorphismButtonState();
}

class _NeumorphismButtonState extends State<NeumorphismButton> {
  bool isPressed = false;
  Completer<void> completer = Completer<void>()..complete();

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 200);
    final color = widget.selectedColor ?? Theme.of(context).backgroundColor;
    return GestureDetector(
      onTapDown: (_) => setState(() {
        if (!widget.isSelected) {
          completer = Completer<void>()..complete(Future.delayed(duration));
          isPressed = true;
        }
      }),
      onTap: widget.onTap,
      onTapUp: (_) => completer.future.then(
        (_) => setState(
          () {
            isPressed = false;
          },
        ),
      ),
      child: AnimatedContainer(
        curve: Curves.bounceInOut,
        duration: duration,
        decoration: BoxDecoration(
          color: isPressed ? Theme.of(context).backgroundColor : color,
          border: isPressed ? null : widget.border,
          shape: BoxShape.circle,
          boxShadow: [
            if (!isPressed)
              const BoxShadow(
                color: Colors.grey,
                offset: Offset(4, 4),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            if (!isPressed)
              const BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 15,
                spreadRadius: 1,
              ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
