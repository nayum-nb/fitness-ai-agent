import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_ai_mobile/services/database_helper.dart';
import 'package:fitness_ai_mobile/providers/fitness_provider.dart';
import 'package:fitness_ai_mobile/models/workout_log.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Riverpod Fitness Provider State Tests', () {
    late ProviderContainer container;
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper.instance;
      container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(dbHelper),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('WorkoutNotifier loads empty list initially for unused date', () async {
      const testDate = '2099-01-01';
      
      // Explicitly await the asynchronous load operation
      final notifier = container.read(workoutProvider(testDate).notifier);
      await notifier.loadWorkouts(testDate);

      final state = container.read(workoutProvider(testDate));
      
      expect(state.value, isNotNull);
      expect(state.value, isEmpty);
    });

    test('WorkoutNotifier updates state reactively when addWorkout is called', () async {
      const testDate = '2026-10-30';
      final notifier = container.read(workoutProvider(testDate).notifier);

      final newWorkout = WorkoutLog(
        date: testDate,
        exerciseName: 'Leg Press',
        sets: 4,
        reps: 12,
        weightLifted: 120.0,
        completed: true,
      );

      await notifier.addWorkout(newWorkout);

      final state = container.read(workoutProvider(testDate));
      expect(state.value, isNotNull);
      expect(state.value!.length, greaterThan(0));
      expect(state.value!.last.exerciseName, 'Leg Press');
    });
  });
}