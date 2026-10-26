import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fitness_ai_mobile/services/database_helper.dart';

void main() {
  // Initialize FFI for running sqflite tests on desktop/host environment
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseHelper Unit Tests', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper.instance;
    });

    test('Database initializes and creates tables successfully', () async {
      final db = await dbHelper.database;
      expect(db.isOpen, true);

      // Verify tables exist by querying sqlite_master
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name IN ('user_profile', 'daily_metrics', 'workout_logs');"
      );
      
      expect(tables.length, 3);
    });

    test('Insert and retrieve workout logs successfully', () async {
      final testWorkout = {
        'date': '2026-10-26',
        'exercise_name': 'Incline Treadmill Walk',
        'sets': 1,
        'reps': 1,
        'weight_lifted': 0.0,
        'completed': 1,
      };

      // 1. Test Insert
      final insertedId = await dbHelper.insertWorkout(testWorkout);
      expect(insertedId, greaterThan(0));

      // 2. Test Retrieve by Date
      final workouts = await dbHelper.getWorkoutsByDate('2026-10-26');
      expect(workouts.isNotEmpty, true);
      expect(workouts.first['exercise_name'], 'Incline Treadmill Walk');
      expect(workouts.first['sets'], 1);
      expect(workouts.first['completed'], 1);
    });
  });
}