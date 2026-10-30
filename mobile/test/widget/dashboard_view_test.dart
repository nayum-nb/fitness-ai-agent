import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_ai_mobile/views/dashboard_view.dart';
import 'package:fitness_ai_mobile/providers/fitness_provider.dart';
import 'package:fitness_ai_mobile/models/daily_metric.dart';
import 'package:fitness_ai_mobile/models/workout_log.dart';
import 'package:fitness_ai_mobile/services/database_helper.dart';

// --- Mock Notifiers (no database access) ---
class MockWorkoutNotifier extends WorkoutNotifier {
  MockWorkoutNotifier(String date) : super(DatabaseHelper.instance) {
    state = AsyncValue.data([
      WorkoutLog(
        id: 1,
        date: date,
        exerciseName: 'Bench Press',
        sets: 3,
        reps: 10,
        weightLifted: 60.0,
        completed: true,
      ),
    ]);
  }

  @override
  Future<void> loadWorkouts(String date) async {}
}

class MockDailyMetricNotifier extends DailyMetricNotifier {
  MockDailyMetricNotifier(String date) : super(DatabaseHelper.instance) {
    state = AsyncValue.data(DailyMetric(
      id: 1,
      date: date,
      weight: 84.2,
      waterIntakeMl: 2500,
      caloriesConsumed: 1800,
    ));
  }

  @override
  Future<void> loadMetric(String date) async {}
}

void main() {
  const testDate = '2026-10-30';

  testWidgets('DashboardView renders title and summary metrics without database locks', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutProvider(testDate).overrideWith((ref) => MockWorkoutNotifier(testDate)),
          dailyMetricProvider(testDate).overrideWith((ref) => MockDailyMetricNotifier(testDate)),
        ],
        child: const MaterialApp(
          home: DashboardView(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Fitness AI Dashboard'), findsOneWidget);
    expect(find.text('Target Weight'), findsOneWidget);
    expect(find.text('Current Weight'), findsOneWidget);
    expect(find.text('84.2 kg'), findsOneWidget);
    expect(find.text('Water Intake'), findsOneWidget);
    expect(find.text('2500 / 3000 ml'), findsOneWidget);
    expect(find.text('Calories'), findsOneWidget);
    expect(find.text('1800 kcal'), findsOneWidget);
    expect(find.text('Bench Press'), findsOneWidget);
  });
}
