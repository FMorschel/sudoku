import 'package:flutter/material.dart';

class SizingBox extends StatefulWidget {
  const SizingBox({
    Key? key,
    this.heightFactor = 1.0,
    this.widthFactor = 1.0,
    this.child = const SizedBox.shrink(),
    this.min,
    this.max,
    this.alignment = Alignment.center,
  })  : assert(heightFactor >= 0),
        assert(heightFactor <= 1),
        assert(heightFactor != double.nan),
        assert(widthFactor >= 0),
        assert(widthFactor <= 1),
        assert(widthFactor != double.nan),
        super(key: key);

  final double heightFactor;
  final double widthFactor;
  final Widget child;
  final AlignmentGeometry alignment;
  final Size? min;
  final Size? max;

  @override
  State<SizingBox> createState() => _SizingBoxState();
}

class _SizingBoxState extends State<SizingBox> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fractioned = Size(
          constraints.biggest.width * widget.widthFactor,
          constraints.biggest.height * widget.heightFactor,
        );
        final max = (widget.max ?? constraints.biggest);
        final min = (widget.min ?? constraints.smallest);
        final size = Size(
          fractioned.width > max.width
              ? max.width
              : fractioned.width < min.width
                  ? min.width
                  : fractioned.width,
          fractioned.height > max.height
              ? max.height
              : fractioned.height < min.height
                  ? min.height
                  : fractioned.height,
        );
        debugPrint('$size');
        return SizedBox.fromSize(
          size: size,
          child: Align(
            alignment: widget.alignment,
            child: widget.child,
          ),
        );
      },
    );
  }
}
