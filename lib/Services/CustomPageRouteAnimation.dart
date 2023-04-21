import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;

  CustomPageRoute({required this.child, this.direction = AxisDirection.right})
      : super(
            transitionDuration: Duration(milliseconds: 270),
            pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(begin: getBeginOffset(), end: Offset.zero)
            .animate(animation),
        child: child,
      );

  getBeginOffset() {
    switch (direction) {
      case AxisDirection.up:
        return Offset(0, 1);
        break;
      case AxisDirection.down:
        return Offset(0, -1);
        break;
      case AxisDirection.right:
        return Offset(1, 0);
        break;
      case AxisDirection.left:
        return Offset(-1, 0);
        break;
    }
  }
}
