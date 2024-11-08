

// lib/data/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tolu_7/data/models/todo.dart';
import 'package:tolu_7/data/models/tasks_data.dart';

class DatabaseHelper {
  static const _databaseName = "todo_app.db";
  static const _databaseVersion = 1;
  static const todoTable = 'todos';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $todoTable (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Basic CRUD operations
  Future<int> insertTodo(Todo todo) async {
    try {
      Database db = await database;
      return await db.insert(todoTable, todo.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<Todo?> getTodoById(String id) async {
    try {
      Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        todoTable,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;
      return Todo.fromMap(maps.first);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Todo>> getAllTodos() async {
    try {
      Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
          todoTable,
          orderBy: 'createdAt DESC'
      );

      return List.generate(maps.length, (i) => Todo.fromMap(maps[i]));
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateTodo(Todo todo) async {
    try {
      Database db = await database;
      return await db.update(
        todoTable,
        todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteTodo(String id) async {
    try {
      Database db = await database;
      return await db.delete(
        todoTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllTodos() async {
    try {
      Database db = await database;
      await db.delete(todoTable);
    } catch (e) {
      rethrow;
    }
  }

  // New methods for TasksData
  Future<TasksData> getTasksData() async {
    try {
      Database db = await database;

      final result = await db.rawQuery('''
        SELECT 
          COUNT(*) as total,
          SUM(CASE WHEN isCompleted = 1 THEN 1 ELSE 0 END) as completed
        FROM $todoTable
      ''');

      final total = Sqflite.firstIntValue(result.map((r) => {'count': r['total']}).toList()) ?? 0;
      final completed = Sqflite.firstIntValue(result.map((r) => {'count': r['completed']}).toList()) ?? 0;

      return TasksData(
        completedTasks: completed,
        totalTasks: total,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get todos by completion status
  Future<List<Todo>> getTodosByStatus(bool isCompleted) async {
    try {
      Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        todoTable,
        where: 'isCompleted = ?',
        whereArgs: [isCompleted ? 1 : 0],
        orderBy: 'createdAt DESC',
      );

      return List.generate(maps.length, (i) => Todo.fromMap(maps[i]));
    } catch (e) {
      rethrow;
    }
  }
}