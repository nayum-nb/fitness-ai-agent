import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_ai_mobile/models/workout_log.dart';
import 'package:fitness_ai_mobile/models/daily_metric.dart';

void main() {
  group('WorkoutLog Model Tests', () {
    test('toMap converts boolean completed to integer 1 or 0', () {
      final completedWorkout = WorkoutLog(
        date: '2026-10-30',
        exerciseName: 'Bench Press',
        sets: 3,
        reps: 10,
        weightLifted: 60.0,
        completed: true,
      );

      final incompleteWorkout = WorkoutLog(
        date: '2026-10-30',
        exerciseName: 'Squat',
        sets: 4,
        reps: 8,
        weightLifted: 80.0,
        completed: false,
      );

      expect(completedWorkout.toMap()['completed'], 1);
      expect(incompleteWorkout.toMap()['completed'], 0);
    });

    test('fromMap correctly parses dynamic num to double for weightLifted', () {
      final mapData = {
        'id': 1,
        'date': '2026-10-30',
        'exercise_name': 'Deadlift',
        'sets': 3,
        'reps': 5,
        'weight_lifted': 100, // Passed as integer from DB query
        'completed': 1,
      };

      final workout = WorkoutLog.fromMap(mapData);
      expect(workout.weightLifted, 100.0);
      expect(workout.completed, true);
    });
  });

  group('DailyMetric Model Tests', () {
    test('fromMap handles null optional fields gracefully', () {
      final mapData = {
        'id': 1,
        'date': '2026-10-30',
        'weight': null,
        'water_intake_ml': null,
        'calories_consumed': null,
      };

      final metric = DailyMetric.fromMap(mapData);
      expect(metric.date, '2026-10-30');
      expect(metric.weight, isNull);
      expect(metric.waterIntakeMl, isNull);
      expect(metric.caloriesConsumed, isNull);
    });
  });
}