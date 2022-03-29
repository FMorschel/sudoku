import 'package:flutter/material.dart';

class NeumorphismButton extends StatefulWidget {
  const NeumorphismButton({
    Key? key,
    this.child = const SizedBox.shrink(),
    this.onTap,
    this.selectedColor,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final Color? selectedColor;

  @override
  State<NeumorphismButton> createState() => _NeumorphismButtonState();
}

class _NeumorphismButtonState extends State<NeumorphismButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() {
        isPressed = true;
      }),
      onTap: widget.onTap,
      onTapUp: (_) => setState(() {
        isPressed = false;
      }),
      child: AnimatedContainer(
        curve: Curves.bounceInOut,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.selectedColor ?? Theme.of(context).backgroundColor,
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
