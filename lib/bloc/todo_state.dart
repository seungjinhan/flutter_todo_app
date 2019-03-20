import 'package:equatable/equatable.dart';
import 'package:my_todo_app/model/todo_model.dart';

abstract class TodoState extends Equatable {
  TodoState([List props = const []]) : super(props);
}

class TodoError extends TodoState {}

// 초기 로딩
class TodoInitState extends TodoState {}

// 로딩중
class TodoLoadingState extends TodoState {}

// 로딩완료
class TodoLoadedState extends TodoState {
  final List<TodoModel> todoModels;
  TodoLoadedState({this.todoModels}) : super([todoModels]);
}

// 입력페이지
class TodoCallInputState extends TodoState {}

// 입력 완료
class TodoDoneInputState extends TodoState {}
