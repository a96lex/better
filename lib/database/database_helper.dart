import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:better/models/event.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
  CREATE TABLE events(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date INTEGER not null
)
''');
  }

  Future<int> createEvent(Event event) async {
    final db = await database;
    final id = await db.insert('events', event.toMap());
    return id;
  }

  Future<Event?> readEvent(int id) async {
    final db = await database;
    final maps = await db.query(
      'events',
      columns: ['id', 'date'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Event>> readAllevents() async {
    final db = await database;
    const orderBy = 'date ASC';
    final result = await db.query('events', orderBy: orderBy);
    return result.map((json) => Event.fromMap(json)).toList();
  }

  Future<int> updateEvent(Event event) async {
    final db = await database;
    return db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEvent(int id) async {
    final db = await database;
    return db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
