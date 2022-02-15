import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class BaseSquare<T> extends StatelessWidget {
  const BaseSquare({
    Key? key,
    required this.value,
    required this.builder,
    this.children = const [],
  }) : super(key: key);

  final Cubit<T> value;
  final List<Widget> children;
  final Widget Function(
    BuildContext context,
    AsyncSnapshot<T> snapshot,
    List<Widget> children
  ) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: value.state,
      stream: value.stream,
      builder: (context, snapshot) => builder(context, snapshot, children),
    );
  }
}
