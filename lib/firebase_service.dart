import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

Future<void> saveExerciseRecord(String exerciseName, int count) async {
  final now = DateTime.now();
  final dayOfWeek = DateFormat('EEEE').format(now); // 예: Monday

  final docRef = FirebaseFirestore.instance
      .collection('exercise_records')
      .doc(dayOfWeek);

  await docRef.set({
    exerciseName: FieldValue.increment(count),
    'updated_at': Timestamp.now(),
  }, SetOptions(merge: true));
}
