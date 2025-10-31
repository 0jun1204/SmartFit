import 'package:flutter/material.dart';

class ExerciseSummaryScreen extends StatelessWidget {
  final String exerciseName;
  final double accuracy;
  final int reps;
  final double calories;

  const ExerciseSummaryScreen({
    super.key,
    required this.exerciseName,
    required this.accuracy,
    required this.reps,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("운동 결과 요약"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "$exerciseName 완료!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildSummaryCard("정확도", "${(accuracy * 100).toStringAsFixed(1)}%"),
            _buildSummaryCard("반복 횟수", "$reps 회"),
            _buildSummaryCard("소모 칼로리", "$calories kcal"),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 운동 선택 화면으로 돌아가기
              },
              child: Text("확인"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
      ),
    );
  }
}
