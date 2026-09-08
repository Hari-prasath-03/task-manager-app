import 'package:flutter/material.dart';

extension AppExtensions on BuildContext {
  NavigationExtension get navigator => NavigationExtension(this);
}

class NavigationExtension {
  final BuildContext context;
  const NavigationExtension(this.context);

  void push(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void pop() {
    Navigator.of(context).pop();
  }
}
