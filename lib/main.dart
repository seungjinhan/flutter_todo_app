import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_todo_app/bloc/todo_bloc.dart';
import 'package:my_todo_app/bloc/todo_event.dart';
import 'package:my_todo_app/bloc/todo_state.dart';
import 'package:my_todo_app/repository/todo_repository.dart';
import 'package:my_todo_app/simple_bloc_delegate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MaterialApp(
        title: 'Todo Demo',
        home: MyHomePage(
          todoRepository: todoRepository,
        ));
  }
}

class MyHomePage extends StatefulWidget {
  final TodoRepository todoRepository;

  const MyHomePage({Key key, @required this.todoRepository}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TodoBloc _todoBloc;
  TodoRepository get todoRepository => widget.todoRepository;

  @override
  void initState() {
    _todoBloc = TodoBloc(todoRepository: todoRepository);
    _todoBloc.dispatch(FetchEvent());
    super.initState();
  }

  Widget _body(TodoState state) {
    if (state is TodoInitState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is TodoLoadingState) {}
    if (state is TodoLoadedState) {
      if (state.todoModels.isEmpty) {
        // 데이터가 없을때 출력
        return Center(child: Text('No Data'));
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _todoBloc,
      builder: (BuildContext context, TodoState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('To do'),
          ),
          body: _body(state),
          floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {_todoBloc.dispatch(event)},
            ),
          ]),
        );
      },
    );
  }

  @override
  void dispose() {
    _todoBloc.dispose();
    super.dispose();
  }
}
