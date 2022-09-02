import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/task.dart';
import 'models/todo.dart';

class DBProvider {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT)",
        );
        await database.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, taskId INTEGER, isDone INTEGER, title TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    final Database db = await initializeDB();
    final id = await db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<Task>> getTasks() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('tasks');
    return queryResult.map((e) => Task.fromMap(e)).toList();
  }

  Future<void> updateTask(Task task) async {
    final Database db = await initializeDB();

    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final Database db = await initializeDB();
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertTodo(Todo todo) async {
    final Database db = await initializeDB();
    final id = await db.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<void> updateTodo(Todo todo) async {
    final Database db = await initializeDB();

    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<List<Todo>> getTodos(int taskId) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('todos', where: 'taskId = ?', whereArgs: [taskId]);
    return queryResult.map((e) => Todo.fromMap(e)).toList();
  }

  Future<void> deleteTodo(int taskId) async {
    final Database db = await initializeDB();
    await db.delete(
      'todos',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
  }

}
