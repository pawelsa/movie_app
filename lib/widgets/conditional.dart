import 'package:flutter/material.dart';

class Conditional extends StatelessWidget {
  final bool condition;
  final WidgetBuilder _ifTrue;
  final WidgetBuilder _ifFalse;

  Conditional.empty({
    @required this.condition,
    @required WidgetBuilder child,
  })  : _ifTrue = child,
        _ifFalse = _emptyBuilder,
        assert(condition != null),
        assert(child != null);

  Conditional(
      {@required this.condition,
      @required WidgetBuilder ifBuilder,
      @required WidgetBuilder elseBuilder})
      : _ifTrue = ifBuilder,
        _ifFalse = elseBuilder,
        assert(condition != null),
        assert(ifBuilder != null),
        assert(elseBuilder != null);

  @override
  Widget build(BuildContext context) {
    return condition ? _ifTrue(context) : _ifFalse(context) ?? Container();
  }
}

Widget _emptyBuilder(BuildContext context) {
  return Container();
}
