import 'package:flutter/material.dart';
import 'input_controller.dart';

class Provider extends InheritedWidget {
  final inputCtrl = InputController();

  Provider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static InputController of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider).inputCtrl;
  }
}
