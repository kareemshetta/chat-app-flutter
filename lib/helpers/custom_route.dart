import 'package:flutter/material.dart';

class CustomRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  CustomRoute({required this.child})
      : super(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondryAnimation) => child);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    return SlideTransition(//offset(x,y)
      position: Tween<Offset>(begin: Offset(-1,0),end: Offset.zero).animate(animation),
      child: child,
    );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {

    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
}
