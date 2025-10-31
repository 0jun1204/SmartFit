import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'posture_screen.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _records = [];
  Set<DateTime> _workoutDays = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchRecordsForDay(_selectedDay!);
    _fetchWorkoutDays();
  }

  Future<void> _fetchWorkoutDays() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('exerciseRecords')
        .get();

    setState(() {
      _workoutDays = snapshot.docs
          .map((doc) {
            final date = (doc.data()['date'] as Timestamp).toDate();
            return DateTime(date.year, date.month, date.day);
          })
          .toSet();
    });
  }

  Future<void> _fetchRecordsForDay(DateTime day) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('exerciseRecords')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        .orderBy('date', descending: true)
        .get();

    setState(() {
      _records = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Widget _buildRecordList() {
    if (_records.isEmpty) {
      return const Center(child: Text("운동 기록이 없습니다."));
    }

    final Map<String, Map<String, dynamic>> grouped = {};
    for (final record in _records) {
      final name = record['exerciseName'];
      if (!grouped.containsKey(name)) {
        grouped[name] = {
          'count': record['count'],
          'calories': record['calories'],
          'accuracy': record['accuracy'],
          'entries': 1,
        };
      } else {
        grouped[name]!['count'] += record['count'];
        grouped[name]!['calories'] += record['calories'];
        grouped[name]!['accuracy'] += record['accuracy'];
        grouped[name]!['entries'] += 1;
      }
    }

    return ListView(
      children: grouped.entries.map((entry) {
        final name = entry.key;
        final data = entry.value;
        final avgAccuracy = data['accuracy'] / data['entries'];

        return ListTile(
          title: Text("$name - ${data['count']}회"),
          subtitle: Text("정확도: ${avgAccuracy.toStringAsFixed(1)}%, 칼로리: ${data['calories']}"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostureScreen(
                  selectedExercise: name == 'pushup'
                      ? ExerciseType.pushup
                      : name == 'lunge'
                      ? ExerciseType.lunge
                      : ExerciseType.squat,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("운동 기록 달력")),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _fetchRecordsForDay(selectedDay);
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (_workoutDays.contains(DateTime(date.year, date.month, date.day))) {
                  return Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.5),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildRecordList()),
        ],
      ),
    );
  }
}
