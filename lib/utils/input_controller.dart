import 'dart:async';
import 'validator.dart';

class InputController with Validator {
  final _titleController = StreamController<String>();
  final _contentController = StreamController<String>();

  Stream<String> get title => _titleController.stream.transform(validateTitle);
  Stream<String> get content => _contentController.stream.transform(validateContent);

  Function(String) get changeTitle => _titleController.sink.add;
  Function(String) get changeContent => _contentController.sink.add;

  dispose() {
    _titleController.close();
    _contentController.close();
  }
}
