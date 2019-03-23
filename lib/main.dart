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
import 'package:my_todo_app/utils/input_controller.dart';
import 'package:my_todo_app/utils/provider.dart';

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
    return Provider(
      child: MaterialApp(
          title: 'Todo Demo',
          home: MyHomePage(
            todoRepository: todoRepository,
          )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final TodoRepository todoRepository;

  const MyHomePage({Key key, @required this.todoRepository}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
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
    final inputCtrl = Provider.of(context);

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
      final _todoTitleController = TextEditingController();
      final _todoContentController = TextEditingController();

      return Container(
        margin: EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              titleField(inputCtrl),
              Container(margin: EdgeInsets.only(bottom: 25.0)),
              contentField(inputCtrl),
              Container(margin: EdgeInsets.only(bottom: 25.0)),
              saveButton(inputCtrl),

              // TextFormField(
              //   decoration: InputDecoration(labelText: 'todo title'),
              //   controller: _todoTitleController,
              // ),
              // TextFormField(
              //   keyboardType: TextInputType.multiline,
              //   maxLines: 5,
              //   decoration: InputDecoration(labelText: 'todo content'),
              //   controller: _todoContentController,
              // ),
              // RaisedButton(
              //   child: Text('SAVE'),
              //   onPressed: () {
              //     _todoBloc.dispatch(TodoSaveButtonEvent(_todoTitleController.text, _todoContentController.text));
              //   },
              // )
            ],
          ),
        ),
      );
    }

    if (state is TodoDoneInputState) {
      _todoBloc.dispatch(FetchEvent());
    }
  }

  Widget titleField(InputController inputCtrl) {
    return StreamBuilder(
      stream: inputCtrl.title,
      builder: (context, snapshot) {
        return TextField(
          onChanged: inputCtrl.changeTitle,
          decoration: InputDecoration(labelText: 'Title', hintText: 'this is title', errorText: snapshot.error),
        );
      },
    );
  }

  Widget contentField(InputController inputCtrl) {
    return StreamBuilder(
      stream: inputCtrl.content,
      builder: (context, snapshot) {
        return TextField(
          onChanged: inputCtrl.changeContent,
          decoration: InputDecoration(labelText: 'Content', hintText: 'this is content', errorText: snapshot.error),
          keyboardType: TextInputType.multiline,
          maxLines: 5,
        );
      },
    );
  }

  Widget saveButton(InputController inputCtrl) {
    return StreamBuilder(
      stream: inputCtrl.saveBtnValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text('save'),
          color: Colors.red,
          onPressed: snapshot.hasData
              ? () {
                  inputCtrl.save(_todoBloc);
                }
              : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _todoBloc,
      builder: (BuildContext context, TodoState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('To do'),
            leading: (state is TodoCallInputState)
                ? Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          _todoBloc.dispatch(FetchEvent());
                        },
                      );
                    },
                  )
                : null,
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
    return Dismissible(
      key: Key("${todo.id}"),
      onDismissed: (dir) {
        todoBloc.dispatch(TodoDeleteEvent(todo.id));
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("${todo.title} remove"),
        ));
      },
      background: Container(
        color: Colors.orangeAccent,
      ),
      child: ListTile(
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
      ),
    );
  }
}
