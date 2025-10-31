import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pose_detector_view.dart';
import 'services/auth_service.dart';

class ExerciseSelectionScreen extends StatelessWidget {
  static const List<Map<String, String>> exercises = [
    {"name": "스쿼트", "type": "squat"},
    {"name": "푸쉬업", "type": "pushup"},
    {"name": "런지", "type": "lunge"},
  ];

  const ExerciseSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text('운동 분석'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PoseDetectorView(
                          exerciseType: exercises[index]["type"]!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(Icons.fitness_center, color: Colors.deepPurple),
                      title: Text(
                        exercises[index]["name"]!,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              },
            ),
          ),

          // ✅ 운동 기록 보기 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/workout-history');
                },
                icon: Icon(Icons.calendar_month),
                label: Text("운동 기록 보기"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
