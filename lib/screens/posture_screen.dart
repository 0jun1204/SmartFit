import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

enum ExerciseType { squat, pushup, lunge }

class PostureScreen extends StatefulWidget {
  final ExerciseType selectedExercise;

  const PostureScreen({super.key, required this.selectedExercise});

  @override
  State<PostureScreen> createState() => _PostureScreenState();
}

class _PostureScreenState extends State<PostureScreen> {
  late ExerciseType _selectedExercise;

  @override
  void initState() {
    super.initState();
    _selectedExercise = widget.selectedExercise;
  }

  String _getModelPath(ExerciseType type) {
    switch (type) {
      case ExerciseType.squat:
        return 'assets/models/human_muscle_squat.glb';
      case ExerciseType.pushup:
        return 'assets/models/human_muscle_pushup.glb';
      case ExerciseType.lunge:
        return 'assets/models/human_muscle_lunge.glb';
    }
  }

  String _getTitle(ExerciseType type) {
    switch (type) {
      case ExerciseType.squat:
        return '스쿼트 근육';
      case ExerciseType.pushup:
        return '푸쉬업 근육';
      case ExerciseType.lunge:
        return '런지 근육';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_selectedExercise)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildExerciseButton(ExerciseType.squat, '스쿼트'),
                _buildExerciseButton(ExerciseType.pushup, '푸쉬업'),
                _buildExerciseButton(ExerciseType.lunge, '런지'),
              ],
            ),
          ),
          Expanded(
            child: ModelViewer(
              key: ValueKey(_selectedExercise), // 이 줄 추가
              src: _getModelPath(_selectedExercise),
              alt: "3D 사람 근육 모형",
              ar: true,
              autoRotate: true,
              cameraControls: true,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseButton(ExerciseType type, String label) {
    final isSelected = _selectedExercise == type;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedExercise = type;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.deepPurple : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }
}
