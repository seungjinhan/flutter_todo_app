import 'dart:async';

class Validator {
  final validateTitle = StreamTransformer<String, String>.fromHandlers(
    handleData: (title, sink) {
      if (title.length > 4) {
        sink.add(title);
      } else {
        sink.addError("Input over 4 char");
      }
    },
  );

  final validateContent = StreamTransformer<String, String>.fromHandlers(handleData: (content, sink) {
    if (content.length > 10) {
      sink.add(content);
    } else {
      sink.addError("Input over 10 char");
    }
  });
}
