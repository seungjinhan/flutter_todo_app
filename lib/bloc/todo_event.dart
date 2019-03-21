import 'package:equatable/equatable.dart';
import 'package:my_todo_app/model/todo_model.dart';

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

  TodoModel get(){

    TodoModel( null, title, content, createDate, isDone, doneDate)    
  }
}
