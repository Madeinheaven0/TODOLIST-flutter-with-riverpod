import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();
  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if(_database != null) return _database!;
    _database = await _initDB("todos.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE Todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL,
        creationDate TEXT NOT NULL
      )
    ''');
    }catch(e) {
      throw Exception('Error to create de table: ${e.toString()}');
    }
  }

  Future<void> close() async {
    try {
      final db = await instance.database;
      db.close();
    }catch(e) {
      throw Exception('Error to close the database: ${e.toString()}');
    }
  }

}