import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/quotes_model.dart';

class DatabaseHelper
{
  static DatabaseHelper databaseHelper = DatabaseHelper._();
  DatabaseHelper._();
  Database? _database;

  Future<Database?> get database async =>
      (_database != null) ? _database : await initDatabase();

  Future<Database?> initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'todo.db');

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            '''CREATE TABLE Quotes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            quote TEXT,
            author TEXT,
            category TEXT,
            is_favorite INTEGER DEFAULT 0
        )''');
      },
    );
    return _database;
  }

  Future<void> insertQuote(QuotesModel quote) async {
    final db = await database;

    await db!.insert(
      'Quotes',
      quote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> deleteQuote(int id) async {
    final db = await database;

    await db!.delete(
      'Quotes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<List<QuotesModel>> fetchFavoriteQuotesByCategory(String category) async {
    final db = await database;

    final maps = await db!.query(
      'Quotes',
      where: 'category = ? AND is_favorite = ?',
      whereArgs: [category, 1],
    );

    return maps.map((e) => QuotesModel.fromMap(e)).toList();
  }

  Future<List<String>> getFavoriteCategories() async {
    final db = await database;

    final maps = await db!.rawQuery('''
    SELECT DISTINCT category
    FROM Quotes
    WHERE is_favorite = 1
  ''');

    return maps.map((map) => map['category'] as String).toList();
  }

  Future<int?> getQuoteId(QuotesModel quote) async {
    final db = await database;

    final maps = await db!.query(
      'Quotes',
      where: 'quote = ? AND author = ?',
      whereArgs: [quote.quote, quote.author],
    );

    if (maps.isNotEmpty) {
      return maps.first['id'] as int;
    }
    return null;
  }

  Future<bool> doesQuoteExist(QuotesModel quote) async {
    final db = await database;

    final maps = await db!.query(
      'Quotes',
      where: 'quote = ? AND author = ?',
      whereArgs: [quote.quote, quote.author],
    );

    return maps.isNotEmpty;

  }


}