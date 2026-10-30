import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/fitness_provider.dart';
import '../models/workout_log.dart';
import '../models/daily_metric.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String todayDate = '2026-10-30';
    final workoutAsync = ref.watch(workoutProvider(todayDate));
    final metricAsync = ref.watch(dailyMetricProvider(todayDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness AI Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Summary Card: Weight Progress ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Column(
                      children: [
                        Text('Target Weight', style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 4),
                        Text('70 kg', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(height: 30, width: 1, color: Colors.grey.shade300),
                    Column(
                      children: [
                        const Text('Current Weight', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        metricAsync.when(
                          data: (metric) => Text(
                            metric?.weight != null ? '${metric!.weight} kg' : 'Not set',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          loading: () => const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                          error: (_, __) => const Text('Error'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Daily Metrics: Water & Calories Tracker ---
            metricAsync.when(
              data: (metric) => Row(
                children: [
                  // Water Intake Card
                  Expanded(
                    child: Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.water_drop, color: Colors.blue, size: 28),
                            const SizedBox(height: 8),
                            const Text('Water Intake', style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(
                              '${metric?.waterIntakeMl ?? 0} / 3000 ml',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Calories Card
                  Expanded(
                    child: Card(
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
                            const SizedBox(height: 8),
                            const Text('Calories', style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(
                              '${metric?.caloriesConsumed ?? 0} kcal',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error loading metrics: $err'),
            ),
            const SizedBox(height: 24),

            const Text(
              "Today's Workout Logs",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // --- Workout List Builder ---
            workoutAsync.when(
              data: (workouts) {
                if (workouts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: Text('No workouts logged for today yet.'),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: Icon(
                          workout.completed ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: workout.completed ? Colors.green : Colors.orange,
                        ),
                        title: Text(workout.exerciseName),
                        subtitle: Text('Sets: ${workout.sets} | Reps: ${workout.reps}'),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error loading workouts: $err'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add sample workout log
          final newWorkout = WorkoutLog(
            date: todayDate,
            exerciseName: 'Treadmill & Core Routine',
            sets: 3,
            reps: 12,
            weightLifted: 0.0,
            completed: true,
          );
          await ref.read(workoutProvider(todayDate).notifier).addWorkout(newWorkout);

          // Upsert sample daily metrics
          final updatedMetric = DailyMetric(
            date: todayDate,
            weight: 84.0,
            waterIntakeMl: 2500,
            caloriesConsumed: 1850,
          );
          await ref.read(dailyMetricProvider(todayDate).notifier).saveMetric(updatedMetric);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}