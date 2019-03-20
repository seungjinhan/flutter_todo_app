import 'package:my_todo_app/model/todo_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TodoRepository {
  final String tableName = 'todo';

  static Database _db;
  Future<Database> get db async {
    if (_db != null) return _db;

    _db = await init();

    return _db;
  }

  TodoRepository() {}

  init() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'data.db');

    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ${tableName} (id INTEGER PRIVARY KEY, title TEXT, content TEXT)");
    });
  }

  Future<List<TodoModel>> getList() async {
    var dbClient = await db;
    print(dbClient.toString());
    List<Map> list = await dbClient.rawQuery("SELECT * FROM ${tableName}");
    List<TodoModel> todoList = new List();
    for (var i = 0; i < todoList.length; i++) {
      todoList.add(new TodoModel(list[i]["id"], list[i]["title"], list[i]["content"], list[i]["create_date"], list[i]["is_done"], list[i]["done_date"]));
    }

    return todoList;
  }

  // 추가
  Future<int> insert(TodoModel model) async {
    var dbClient = await db;

    await dbClient.transaction((tx) async {
      return await tx.insert(tableName, model.toMap());
    });
    return 0;
  }

  // 삭제처리
  Future<int> delete(int id) async {
    var dbClient = await db;

    await dbClient.transaction((tx) async {
      return await tx.delete(tableName, where: 'id=?', whereArgs: [id]);
    });

    return 0;
  }

  // 업데이트
  Future<int> update(TodoModel model) async {
    var dbClient = await db;

    await dbClient.transaction((tx) async {
      return await tx.update(tableName, model.toMap(), where: 'id=?', whereArgs: [model.id]);
    });

    return 0;
  }
}
