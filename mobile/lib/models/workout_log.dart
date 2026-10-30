class WorkoutLog {
  final int? id;
  final String date;
  final String exerciseName;
  final int sets;
  final int reps;
  final double weightLifted;
  final bool completed;

  WorkoutLog({
    this.id,
    required this.date,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.weightLifted,
    required this.completed,
  });

  // Convert WorkoutLog object to Map for SQLite insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'exercise_name': exerciseName,
      'sets': sets,
      'reps': reps,
      'weight_lifted': weightLifted,
      'completed': completed ? 1 : 0, // SQLite stores booleans as integers (0 or 1)
    };
  }

  // Create a WorkoutLog object from a SQLite Map query result
  factory WorkoutLog.fromMap(Map<String, dynamic> map) {
    return WorkoutLog(
      id: map['id'],
      date: map['date'],
      exerciseName: map['exercise_name'],
      sets: map['sets'],
      reps: map['reps'],
      weightLifted: (map['weight_lifted'] as num).toDouble(),
      completed: map['completed'] == 1,
    );
  }
}
