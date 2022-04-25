import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultShortcuts extends StatelessWidget {
  const DefaultShortcuts({
    required this.child,
    required this.nextFocus,
    required this.previousFocus,
    required this.upFocus,
    required this.downFocus,
    this.shortcuts,
    this.actions,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final VoidCallback nextFocus;
  final VoidCallback previousFocus;
  final VoidCallback upFocus;
  final VoidCallback downFocus;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;

  static const _shortcuts = {
    SingleActivator(
      LogicalKeyboardKey.tab,
      shift: true,
    ): _MoveFocusIntent(_Direction.left),
    SingleActivator(
      LogicalKeyboardKey.arrowLeft,
    ): _MoveFocusIntent(_Direction.left),
    SingleActivator(
      LogicalKeyboardKey.keyA,
    ): _MoveFocusIntent(_Direction.left),
    SingleActivator(
      LogicalKeyboardKey.tab,
    ): _MoveFocusIntent(_Direction.right),
    SingleActivator(
      LogicalKeyboardKey.arrowRight,
    ): _MoveFocusIntent(_Direction.right),
    SingleActivator(
      LogicalKeyboardKey.keyD,
    ): _MoveFocusIntent(_Direction.right),
    SingleActivator(
      LogicalKeyboardKey.arrowUp,
    ): _MoveFocusIntent(_Direction.up),
    SingleActivator(
      LogicalKeyboardKey.keyW,
    ): _MoveFocusIntent(_Direction.up),
    SingleActivator(
      LogicalKeyboardKey.arrowDown,
    ): _MoveFocusIntent(_Direction.down),
    SingleActivator(
      LogicalKeyboardKey.keyS,
    ): _MoveFocusIntent(_Direction.down),
  };

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {}
        ..addAll(shortcuts ?? {})
        ..addAll(_shortcuts),
      child: Actions(
        actions: {}
          ..addAll(actions ?? {})
          ..addAll({
            _MoveFocusIntent: _MoveFocusAction(
              right: nextFocus,
              left: previousFocus,
              down: downFocus,
              up: upFocus,
            ),
          }),
        child: child,
      ),
    );
  }
}

class _MoveFocusAction<T extends _MoveFocusIntent> extends Action<T> {
  _MoveFocusAction({
    required this.up,
    required this.down,
    required this.left,
    required this.right,
  });

  final VoidCallback up;
  final VoidCallback down;
  final VoidCallback left;
  final VoidCallback right;

  @override
  Object? invoke(T intent) {
    switch (intent.direction) {
      case _Direction.up:
        up();
        break;
      case _Direction.down:
        down();
        break;
      case _Direction.left:
        left();
        break;
      case _Direction.right:
        right();
        break;
    }
    return null;
  }
}

class _MoveFocusIntent extends Intent {
  const _MoveFocusIntent(this.direction);
  final _Direction direction;
}

enum _Direction {
  up,
  down,
  left,
  right,
}
