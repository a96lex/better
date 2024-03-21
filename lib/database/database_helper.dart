import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:better/models/event.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  final _updateStreamController = StreamController<void>.broadcast();

  Stream<void> get onUpdate => _updateStreamController.stream;

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
  date INTEGER not null,
  text VARCHAR(1000)
)
''');
  }

  Future<int> createEvent(Event event) async {
    final db = await database;
    final id = await db.insert('events', event.toMap());

    _updateStreamController.add(null);

    return id;
  }

  Future<Event?> readEvent(int id) async {
    final db = await database;
    final maps = await db.query(
      'events',
      columns: ['id', 'date', 'text'],
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
    return await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEvent(int id) async {
    final db = await database;
    return await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllEvents() async {
    final db = await database;
    await db.delete(
      'events',
    );
    _updateStreamController.add(null);
    return 1;
  }

  Future<Event?> readLastEvent() async {
    final db = await database;
    const orderBy = 'date DESC';
    final result = await db.query('events', orderBy: orderBy, limit: 1);

    // if empty, return null
    if (result.isEmpty) {
      return null;
    }
    return Event.fromMap(result.first);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
