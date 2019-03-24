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

class TodoSaveButtonEvent extends TodoEvent {
  final String title;
  final String content;

  TodoSaveButtonEvent(this.title, this.content);
}

class TodoCheckEvent extends TodoEvent {
  final bool isCheck;
  final int id;

  TodoCheckEvent(this.id, this.isCheck);
}

class TodoDeleteEvent extends TodoEvent {
  final int id;

  TodoDeleteEvent(this.id);
}
