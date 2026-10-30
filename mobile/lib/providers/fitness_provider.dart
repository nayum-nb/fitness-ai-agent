import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/workout_log.dart';
import '../models/daily_metric.dart';
import '../services/database_helper.dart';

// 1. Database Helper Provider
final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

// 2. Workout State Notifier to manage loading and CRUD reactive state
class WorkoutNotifier extends StateNotifier<AsyncValue<List<WorkoutLog>>> {
  final DatabaseHelper _dbHelper;

  WorkoutNotifier(this._dbHelper) : super(const AsyncValue.loading());

  Future<void> loadWorkouts(String date) async {
    state = const AsyncValue.loading();
    try {
      final workouts = await _dbHelper.getWorkoutLogsByDate(date);
      state = AsyncValue.data(workouts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addWorkout(WorkoutLog workout) async {
    await _dbHelper.insertWorkoutModel(workout);
    await loadWorkouts(workout.date);
  }
}

// 3. Family Provider indexed by Date string (e.g., '2026-10-30')
final workoutProvider = StateNotifierProvider.family<WorkoutNotifier, AsyncValue<List<WorkoutLog>>, String>((ref, date) {
  final dbHelper = ref.watch(databaseProvider);
  return WorkoutNotifier(dbHelper)..loadWorkouts(date);
});

// 4. Daily Metric State Notifier
class DailyMetricNotifier extends StateNotifier<AsyncValue<DailyMetric?>> {
  final DatabaseHelper _dbHelper;

  DailyMetricNotifier(this._dbHelper) : super(const AsyncValue.loading());

  Future<void> loadMetric(String date) async {
    state = const AsyncValue.loading();
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'daily_metrics',
        where: 'date = ?',
        whereArgs: [date],
      );

      if (result.isNotEmpty) {
        state = AsyncValue.data(DailyMetric.fromMap(result.first));
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveMetric(DailyMetric metric) async {
    await _dbHelper.upsertDailyMetric(metric);
    await loadMetric(metric.date);
  }
}

// 5. Daily Metric Family Provider (Indexed by Date string)
final dailyMetricProvider = StateNotifierProvider.family<
    DailyMetricNotifier,
    AsyncValue<DailyMetric?>,
    String>((ref, date) {
  final dbHelper = ref.watch(databaseProvider);
  return DailyMetricNotifier(dbHelper)..loadMetric(date);
});