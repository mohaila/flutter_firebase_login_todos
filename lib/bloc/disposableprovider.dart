import 'package:flutter/material.dart';

import 'disposable.dart';

class DisposableProvider<T extends Disposable> extends StatefulWidget {
  DisposableProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  State createState() => _DisposableProviderState<T>();

  static T of<T extends Disposable>(BuildContext context) {
    final type = _typeOf<DisposableProvider<T>>();
    DisposableProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _DisposableProviderState<T>
    extends State<DisposableProvider<Disposable>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
