import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:winr/core/appmodels/record.dart';

class RecordDatabase {
  Database? _recordDatabase;

  // 🔹 StreamController for live updates
  final _recordsController = StreamController<List<WinRateRecords>>.broadcast();

  Stream<List<WinRateRecords>> get recordsStream {
    // Trigger initial load every time someone subscribes
    _refreshRecords();
    return _recordsController.stream;
  }

  Future<Database> get detectionDb async {
    if (_recordDatabase != null) return _recordDatabase!;
    _recordDatabase = await initializeDatabase();
    return _recordDatabase!;
  }

  Future<String> get localPath async {
    const name = 'records.db';
    final path = await getDatabasesPath();
    return p.join(path, name);
  }

  Future<Database> initializeDatabase() async {
    final path = await localPath;

    // await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true,
    );
  }

  Future<void> create(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timeAdded INTEGER NOT NULL,
        lastUpdated INTEGER,
        backgroundImage TEXT,
        name TEXT,
        desiredWinRate INTEGER NOT NULL,
        currentNumberOfBattles INTEGER NOT NULL,
        currentWinRate INTEGER NOT NULL,
        progressiveWinRate INTEGER
      )
    ''');
  }

  // ----------------------
  // CRUD Operations
  // ----------------------

  /// Insert a record
  Future<int> insertRecord(WinRateRecords record) async {
    final db = await detectionDb;
    final id = await db.insert(
      'records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _refreshRecords();
    return id;
  }

  /// Get all records
  Future<List<WinRateRecords>> getRecords() async {
    final db = await detectionDb;
    final result = await db.query('records', orderBy: 'timeAdded DESC');
    return result.map((e) => WinRateRecords.fromMap(e)).toList();
  }

  /// Stream helper
  Future<void> _refreshRecords() async {
    final records = await getRecords();
    if (!_recordsController.isClosed) {
      _recordsController.add(records);
    }
  }

  /// Get a record by ID
  Future<WinRateRecords?> getRecord(int id) async {
    final db = await detectionDb;
    final result = await db.query(
      'records',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return WinRateRecords.fromMap(result.first);
    }
    return null;
  }

  /// Update a record by ID
  Future<int> updateRecord(int id, WinRateRecords record) async {
    final db = await detectionDb;
    final rows = await db.update(
      'records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
    await _refreshRecords();
    return rows;
  }

  /// Delete a record by ID
  Future<int> deleteRecord(int id) async {
    final db = await detectionDb;
    final rows = await db.delete('records', where: 'id = ?', whereArgs: [id]);
    await _refreshRecords();
    return rows;
  }

  /// Delete all records
  Future<int> deleteAllRecords() async {
    final db = await detectionDb;
    final rows = await db.delete('records');
    await _refreshRecords();
    return rows;
  }

  /// Dispose the controller
  void dispose() {
    _recordsController.close();
  }
}
