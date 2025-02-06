import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'game_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE highscore (
            id INTEGER PRIMARY KEY,
            score REAL,
            mistakes INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertHighScore(double score, int mistakes) async {
    final db = await database;
    await db.insert(
      'highscore',
      {'score': score, 'mistakes': mistakes},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getHighScore() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('highscore');
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }
}
