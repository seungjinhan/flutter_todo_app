import 'package:flutter/material.dart';
import 'package:my_todo_app/rxdart/todo_rxdart.dart';

class RxDartProvider extends InheritedWidget {
  final todoRxDart = TodoRxDart();

  RxDartProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static TodoRxDart of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(RxDartProvider) as RxDartProvider).todoRxDart;
  }
}
