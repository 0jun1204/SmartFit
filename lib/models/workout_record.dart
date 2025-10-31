class WorkoutRecord {
  final String id;
  final String userId;
  final String exerciseName;
  final int duration; // 운동 시간 (분)
  final int calories; // 소모 칼로리
  final DateTime date;
  final String notes;

  WorkoutRecord({
    required this.id,
    required this.userId,
    required this.exerciseName,
    required this.duration,
    required this.calories,
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'exerciseName': exerciseName,
      'duration': duration,
      'calories': calories,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory WorkoutRecord.fromMap(Map<String, dynamic> map) {
    return WorkoutRecord(
      id: map['id'],
      userId: map['userId'],
      exerciseName: map['exerciseName'],
      duration: map['duration'],
      calories: map['calories'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }
} 