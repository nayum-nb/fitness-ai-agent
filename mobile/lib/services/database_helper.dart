import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/workout_log.dart';
import '../models/daily_metric.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fitness_ai.db');
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
    // 1. User Profile Table
    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER,
        height REAL,
        weight REAL,
        target_weight REAL,
        goal TEXT
      )
    ''');

    // 2. Daily Metrics Table (Weight, Water, Calories)
    await db.execute('''
      CREATE TABLE daily_metrics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        weight REAL,
        water_intake_ml INTEGER,
        calories_consumed INTEGER
      )
    ''');

    // 3. Workout Logs Table
    await db.execute('''
      CREATE TABLE workout_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        exercise_name TEXT NOT NULL,
        sets INTEGER,
        reps INTEGER,
        weight_lifted REAL,
        completed INTEGER
      )
    ''');
  }

  // --- Insert Workout using Model ---
  Future<int> insertWorkoutModel(WorkoutLog workout) async {
    final db = await instance.database;
    return await db.insert('workout_logs', workout.toMap());
  }

  // --- CRUD Method: Get Workouts by Date ---
  Future<List<WorkoutLog>> getWorkoutLogsByDate(String date) async {
    final db = await instance.database;
    final result = await db.query(
      'workout_logs',
      where: 'date = ?',
      whereArgs: [date],
    );
    return result.map((json) => WorkoutLog.fromMap(json)).toList();
  }

  // --- Upsert Daily Metrics ---
  Future<int> upsertDailyMetric(DailyMetric metric) async {
    final db = await instance.database;
    return await db.insert(
      'daily_metrics',
      metric.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  // Add this inside your DatabaseHelper class
  Future<void> clearAllTables() async {
    final db = await instance.database;
    await db.delete('workout_logs');
    await db.delete('daily_metrics');
    await db.delete('user_profile');
  }
}