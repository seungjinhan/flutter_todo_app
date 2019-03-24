import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_todo_app/pages/todo_page.dart';
import 'package:my_todo_app/repository/todo_repository.dart';
import 'package:my_todo_app/rxdart/rxdart_provider.dart';
import 'package:my_todo_app/simple_bloc_delegate.dart';
import 'package:meta/meta.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MyApp(
    todoRepository: TodoRepository(),
  ));
}

class MyApp extends StatelessWidget {
  final TodoRepository todoRepository;

  MyApp({Key key, @required this.todoRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RxDartProvider(
      child: MaterialApp(
          title: 'Todo Demo',
          home: TodoPage(
            todoRepository: todoRepository,
          )),
    );
  }
}
