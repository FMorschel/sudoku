import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class NeumorphismButton extends StatefulWidget {
  const NeumorphismButton({
    Key? key,
    this.child = const SizedBox.shrink(),
    this.onTap,
    this.border,
    this.onLongPress,
    this.selectedColor,
    this.isSelected = false,
  }) : super(key: key);

  final Widget child;
  final bool isSelected;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? selectedColor;

  @override
  State<NeumorphismButton> createState() => _NeumorphismButtonState();
}

class _NeumorphismButtonState extends State<NeumorphismButton> {
  static const duration = Duration(milliseconds: 200);

  bool isPressed = false;
  Completer<void> completer = Completer<void>()..complete();
  static const shadows = [
    BoxShadow(
      color: Colors.grey,
      offset: Offset(4, 4),
      blurRadius: 15,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: Colors.white,
      offset: Offset(-4, -4),
      blurRadius: 15,
      spreadRadius: 1,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final color = widget.selectedColor ?? Theme.of(context).backgroundColor;
    return GestureDetector(
      onTapDown: (widget.onTap != null)
          ? (_) => setState(() {
                if (!isPressed) {
                  completer = Completer<void>()
                    ..complete(Future.delayed(duration));
                  isPressed = true;
                }
              })
          : null,
      onTap: widget.onTap,
      onLongPress: (widget.onLongPress != null)
          ? () {
              setState(() {
                if (!isPressed) {
                  completer = Completer<void>()
                    ..complete(Future.delayed(duration));
                  isPressed = true;
                }
              });
              widget.onLongPress!();
            }
          : null,
      onLongPressUp: (widget.onLongPress != null)
          ? () => completer.future.then(
                (_) => setState(() {
                  isPressed = false;
                }),
              )
          : null,
      onTapUp: (widget.onTap != null)
          ? (_) => completer.future.then(
                (_) => setState(() {
                  isPressed = false;
                }),
              )
          : null,
      child: AnimatedContainer(
        curve: Curves.bounceInOut,
        duration: duration,
        decoration: BoxDecoration(
          color: isPressed ? Theme.of(context).backgroundColor : color,
          border: isPressed ? null : widget.border,
          shape: BoxShape.circle,
          boxShadow: isPressed ? null : shadows,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final squareSide = constraints.biggest.shortestSide / pow(2, 1 / 2);
            return Center(
              child: SizedBox.fromSize(
                size: Size.square(squareSide),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}
