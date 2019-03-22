import 'dart:convert';

class TodoModel {
  int id;
  String title;
  String content;
  String createDate;
  int isDone;
  String doneDate;

  TodoModel(this.id, this.title, this.content, this.createDate, this.isDone, this.doneDate);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'title': title, 'content': content, 'is_done': isDone, 'done_date': doneDate};
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  TodoModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    content = map['content'];
    createDate = map['create_date'];
    isDone = map['is_done'];
    doneDate = map['done_date'];
  }
}
