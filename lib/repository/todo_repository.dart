import 'package:my_todo_app/model/todo_model.dart';
import 'package:my_todo_app/utils/util.dart';
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
    String path = join(dbPath, 'data3.db');

    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ${tableName} (id INTEGER PRIVARY KEY, title TEXT, content TEXT, is_done INTEGER, done_date TEXT)");
    });
  }

  Future<List<TodoModel>> getList() async {
    var dbClient = await db;
    print(dbClient.toString());
    List<Map> list = await dbClient.rawQuery("SELECT * FROM ${tableName} order by id desc");
    List<TodoModel> todoList = new List();
    for (var i = 0; i < list.length; i++) {
      todoList.add(new TodoModel(list[i]["id"], list[i]["title"], list[i]["content"], list[i]["create_date"], list[i]["is_done"], list[i]["done_date"]));
    }

    return todoList;
  }

  Future<TodoModel> getOne(int id) async {
    var dbClient = await db;

    List<Map> list = await dbClient.rawQuery("SELECT * FROM ${tableName} WHERE id = ${id} order by id desc");

    var i = 0;
    TodoModel result = new TodoModel(list[i]["id"], list[i]["title"], list[i]["content"], list[i]["create_date"], list[i]["is_done"], list[i]["done_date"]);

    return result;
  }

  // 추가
  Future<int> insert(TodoModel model) async {
    var dbClient = await db;

    await dbClient.transaction((tx) async {
      int result = await tx.rawInsert(
          'INSERT INTO ${tableName} (id , title, content, is_done, done_date) VALUES ( ? ,? , ? , ?,?)', [Util.today(), "${model.title}", "${model.content}", model.isDone, "${model.doneDate}"]);

      return result;
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
  Future<int> update(int id, bool isCheck) async {
    var dbClient = await db;

    await dbClient.transaction((tx) async {
      return await tx.rawUpdate("UPDATE ${tableName} SET is_done = ?, done_date = ? WHERE id = ?", [isCheck == true ? 1 : 0, isCheck == true ? Util.today() : '', id]);
    });

    return 0;
  }
}
