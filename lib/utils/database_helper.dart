import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

import '../model/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  final _lock = Lock();

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _lock.synchronized(initDb);
    return _db;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'Todos.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $tableTodo ("
        "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$columnName TEXT,"
        "$columnType TEXT,"
        "$columnFinished INT,"
        "$columnCreatedTimestamp TEXT)");
  }

  Future<int> saveTodo(Todo todo) async {
    final dbClient = await db;
    return await dbClient.insert(tableTodo, todo.toMap());
  }

  Future<int> updateTodo(Todo todo) async {
    final dbClient = await db;
    return await dbClient.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future<int> removeTodo(Todo todo) async {
    final dbClient = await db;
    return await dbClient.delete(tableTodo, where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future<List<Todo>> getAllTodos() async {
    var dbClient = await db;
    var result = await dbClient.query(tableTodo);
    return result.map((t) => Todo.fromMap(t)).toList();
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
