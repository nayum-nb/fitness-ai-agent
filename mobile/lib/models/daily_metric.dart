class DailyMetric {
  final int? id;
  final String date;
  final double? weight;
  final int? waterIntakeMl;
  final int? caloriesConsumed;

  DailyMetric({
    this.id,
    required this.date,
    this.weight,
    this.waterIntakeMl,
    this.caloriesConsumed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'weight': weight,
      'water_intake_ml': waterIntakeMl,
      'calories_consumed': caloriesConsumed,
    };
  }

  factory DailyMetric.fromMap(Map<String, dynamic> map) {
    return DailyMetric(
      id: map['id'],
      date: map['date'],
      weight: map['weight'] != null ? (map['weight'] as num).toDouble() : null,
      waterIntakeMl: map['water_intake_ml'],
      caloriesConsumed: map['calories_consumed'],
    );
  }
}
