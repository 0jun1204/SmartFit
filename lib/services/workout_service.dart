import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_record.dart';

class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 운동 기록 추가
  Future<void> addWorkoutRecord(WorkoutRecord record) async {
    try {
      await _firestore.collection('workouts').doc(record.id).set(record.toMap());
    } catch (e) {
      print('운동 기록 추가 에러: $e');
      rethrow;
    }
  }

  // 사용자의 운동 기록 조회
  Stream<List<WorkoutRecord>> getUserWorkouts(String userId) {
    return _firestore
        .collection('workouts')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => WorkoutRecord.fromMap(doc.data()))
          .toList();
    });
  }

  // 운동 기록 수정
  Future<void> updateWorkoutRecord(WorkoutRecord record) async {
    try {
      await _firestore.collection('workouts').doc(record.id).update(record.toMap());
    } catch (e) {
      print('운동 기록 수정 에러: $e');
      rethrow;
    }
  }

  // 운동 기록 삭제
  Future<void> deleteWorkoutRecord(String recordId) async {
    try {
      await _firestore.collection('workouts').doc(recordId).delete();
    } catch (e) {
      print('운동 기록 삭제 에러: $e');
      rethrow;
    }
  }
} 