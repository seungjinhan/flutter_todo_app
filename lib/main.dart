import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_todo_app/bloc/todo_bloc.dart';
import 'package:my_todo_app/bloc/todo_event.dart';
import 'package:my_todo_app/bloc/todo_state.dart';
import 'package:my_todo_app/model/todo_model.dart';
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
  final _todoTitleController = TextEditingController();
  final _todoContentController = TextEditingController();

  final _scrollController = ScrollController();

  final _scrollthreshold = 200.0;

  TodoBloc _todoBloc;
  TodoRepository get todoRepository => widget.todoRepository;

  _MyHomePageState() {
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll <= _scrollthreshold) {
      _todoBloc.dispatch(FetchEvent());
    }
  }

  @override
  void initState() {
    _todoBloc = TodoBloc(todoRepository: todoRepository);
    _todoBloc.dispatch(FetchEvent());
    super.initState();
  }

  Widget _body(BuildContext context, TodoState state) {
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
      } else {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return TodoWidget(
              todoBloc: _todoBloc,
              todo: state.todoModels[index],
            );
          },
          controller: _scrollController,
          itemCount: state.todoModels.length,
        );
      }
    }
    if (state is TodoCallInputState) {
      return Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'todo title'),
              controller: _todoTitleController,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: InputDecoration(labelText: 'todo content'),
              controller: _todoContentController,
            ),
            RaisedButton(
              child: Text('SAVE'),
              onPressed: () {
                _todoBloc.dispatch(TodoSaveButtonEvent(_todoTitleController.text, _todoContentController.text));
              },
            )
          ],
        ),
      );
    }

    if (state is TodoDoneInputState) {
      _todoBloc.dispatch(FetchEvent());
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
          body: _body(context, state),
          floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _todoBloc.dispatch(InputEvent());
              },
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

class TodoWidget extends StatelessWidget {
  final TodoModel todo;
  final TodoBloc todoBloc;
  const TodoWidget({Key key, this.todoBloc, this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: todo.isDone == 1 ? true : false,
        onChanged: (bool isCheck) {
          todoBloc.dispatch(TodoCheckEvent(todo.id, isCheck));
        },
      ),
      title: Text(todo.title),
      isThreeLine: true,
      subtitle: Text(todo.content),
      dense: true,
    );
  }
}
