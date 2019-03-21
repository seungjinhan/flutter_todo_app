import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_todo_app/model/todo_model.dart';
import 'package:my_todo_app/repository/todo_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;

  TodoBloc({@required this.todoRepository}) : assert(todoRepository != null);

  @override
  TodoState get initialState => TodoInitState();

  @override
  Stream<TodoEvent> transform(Stream<TodoEvent> events) {
    return (events as Observable<TodoEvent>).debounce(
      Duration(microseconds: 500),
    );
  }

  @override
  Stream<TodoState> mapEventToState(TodoState currentState, TodoEvent event) async* {
    if (event is FetchEvent) {
      try {
        // 초기호출때
        if (currentState is TodoInitState) {
          List<TodoModel> result = await todoRepository.getList();

          yield TodoLoadedState(todoModels: result);
        }
        if (currentState is TodoLoadingState) {}
        if (currentState is TodoLoadedState) {}
      } catch (_) {
        yield TodoError();
      }

      // 글쓰기 이벤트 호출일때
    } else if (event is InputEvent) {
      try {
        if (currentState is TodoLoadedState) {
          yield TodoCallInputState(); // 입력 화면 호출
        }
        if (currentState is TodoDoneInputState) {}
      } catch (_) {
        yield TodoError();
      }
    } else if(event is TodoSaveButtonEvent){

      await todoRepository.insert(model)
    }
  }
}
