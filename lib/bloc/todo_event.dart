import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {}

class FetchEvent extends TodoEvent {
  @override
  String toString() {
    return 'FetchEvent';
  }
}

class InputEvent extends TodoEvent {
  @override
  String toString() {
    return 'InputEvent';
  }
}
