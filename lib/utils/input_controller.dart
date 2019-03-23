import 'dart:async';
import 'package:my_todo_app/bloc/todo_bloc.dart';
import 'package:my_todo_app/bloc/todo_event.dart';

import 'validator.dart';
import 'package:rxdart/rxdart.dart';

class InputController with Validator {
  final _titleController = BehaviorSubject<String>();
  final _contentController = BehaviorSubject<String>();

  Stream<String> get title => _titleController.stream.transform(validateTitle);
  Stream<String> get content => _contentController.stream.transform(validateContent);

  Stream<bool> get saveBtnValid => Observable.combineLatest2(title, content, (t, c) => true);
  Function(String) get changeTitle => _titleController.sink.add;
  Function(String) get changeContent => _contentController.sink.add;

  save(TodoBloc _todoBloc) {
    final title = _titleController.value;
    final content = _contentController.value;
    _todoBloc.dispatch(TodoSaveButtonEvent(title, content));
  }

  dispose() {
    _titleController.close();
    _contentController.close();
  }
}
