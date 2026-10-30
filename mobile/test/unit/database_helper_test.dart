import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fitness_ai_mobile/services/database_helper.dart';
import 'package:fitness_ai_mobile/models/workout_log.dart';
import 'package:fitness_ai_mobile/models/daily_metric.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseHelper Model-Based Unit Tests', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper.instance;
    });

    test('Database initializes and creates tables successfully', () async {
      final db = await dbHelper.database;
      expect(db.isOpen, true);

      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name IN ('user_profile', 'daily_metrics', 'workout_logs');"
      );
      expect(tables.length, 3);
    });

    test('Insert and retrieve WorkoutLog model successfully', () async {
      final testWorkout = WorkoutLog(
        date: '2026-10-30',
        exerciseName: 'Treadmill Jog',
        sets: 3,
        reps: 10,
        weightLifted: 0.0,
        completed: true,
      );

      // 1. Test Insert Model
      final insertedId = await dbHelper.insertWorkoutModel(testWorkout);
      expect(insertedId, greaterThan(0));

      // 2. Test Retrieve Models by Date
      final workouts = await dbHelper.getWorkoutLogsByDate('2026-10-30');
      expect(workouts.isNotEmpty, true);
      expect(workouts.first.exerciseName, 'Treadmill Jog');
      expect(workouts.first.sets, 3);
      expect(workouts.first.completed, true);
    });

    test('Upsert and track DailyMetric model successfully', () async {
      final metric = DailyMetric(
        date: '2026-10-30',
        weight: 84.0,
        waterIntakeMl: 2500,
        caloriesConsumed: 2000,
      );

      // 1. Test Upsert
      final id = await dbHelper.upsertDailyMetric(metric);
      expect(id, greaterThan(0));
    });
  });
}