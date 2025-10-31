import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'camera_view.dart';
import 'pose_painter.dart';
import 'exercise_summary_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;
import 'package:just_audio/just_audio.dart';

class PoseDetectorView extends StatefulWidget {
  final String exerciseType;
  const PoseDetectorView({super.key, required this.exerciseType});

  @override
  State<PoseDetectorView> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  DateTime? _lastAlertTime;

  double _accuracy = 0.0;
  int _reps = 0;
  bool _isSquatting = false;
  int _frameCount = 0;

  double _leftKneeAngle = 0.0;
  double _rightKneeAngle = 0.0;
  double _leftHipAngle = 0.0;
  double _rightHipAngle = 0.0;
  double _torsoAngle = 0.0;

  String _feedbackText = "운동 분석 중...";
  Color _feedbackColor = Colors.white;

  @override
  void dispose() {
    _canProcess = false;
    _poseDetector.close();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraView(
            customPaint: _customPaint,
            onImage: (inputImage) {
              _processImage(inputImage);
            },
          ),
          _buildOverlayUI(),
        ],
      ),
    );
  }

  Widget _buildOverlayUI() {
    return Column(
      children: [
        _buildStatusBar(),
        Spacer(),
        _buildFeedback(),
        _buildFinishButton(),
      ],
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("정확도: ${(_accuracy * 100).round()}%",
                  style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
              Text("반복 횟수: $_reps 회",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Center(
        child: Text(
          _feedbackText,
          style: TextStyle(
              color: _feedbackColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () async {
          String exerciseName = widget.exerciseType;
          double accuracyPercent = _accuracy * 100;
          double calories = _reps * 0.5;

          try {
            await _saveExerciseRecord(
              exerciseName: exerciseName,
              count: _reps,
              accuracy: accuracyPercent,
              calories: calories,
            );
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("운동 저장 중 오류 발생: $e")));
            }
            return;
          }

          if (!mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseSummaryScreen(
                exerciseName: exerciseName,
                accuracy: _accuracy,
                reps: _reps,
                calories: calories,
              ),
            ),
          );
        },
        child: Text("운동 완료"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;
    _isBusy = true;
    _frameCount++;
    if (_frameCount <= 5) {
      _isBusy = false;
      return;
    }

    final poses = await _poseDetector.processImage(inputImage);
    final size = inputImage.metadata?.size;
    final rotation = inputImage.metadata?.rotation;

    if (size != null && rotation != null) {
      _customPaint = CustomPaint(painter: PosePainter(poses, size, rotation));
      _analyzePose(poses.first);
    } else {
      _customPaint = null;
    }

    _isBusy = false;
    if (mounted) setState(() {});
  }

  void _analyzePose(Pose pose) {
    _accuracy = _calculatePoseAccuracy([pose]);

    final landmarks = pose.landmarks;

    final leftShoulder = landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = landmarks[PoseLandmarkType.rightShoulder];
    final leftHip = landmarks[PoseLandmarkType.leftHip];
    final rightHip = landmarks[PoseLandmarkType.rightHip];
    final leftKnee = landmarks[PoseLandmarkType.leftKnee];
    final rightKnee = landmarks[PoseLandmarkType.rightKnee];
    final leftAnkle = landmarks[PoseLandmarkType.leftAnkle];
    final rightAnkle = landmarks[PoseLandmarkType.rightAnkle];
    final leftElbow = landmarks[PoseLandmarkType.leftElbow];
    final rightElbow = landmarks[PoseLandmarkType.rightElbow];
    final leftWrist = landmarks[PoseLandmarkType.leftWrist];
    final rightWrist = landmarks[PoseLandmarkType.rightWrist];

    if ([leftHip, rightHip, leftKnee, rightKnee, leftAnkle, rightAnkle]
        .contains(null)) return;

    _leftKneeAngle = _calculateAngle(leftHip!, leftKnee!, leftAnkle!);
    _rightKneeAngle = _calculateAngle(rightHip!, rightKnee!, rightAnkle!);
    _torsoAngle = _calculateAngle(leftShoulder!, leftHip, rightHip);

    switch (widget.exerciseType) {
      case 'squat':
        _analyzeSquatPose(pose);
        break;
      case 'pushup':
        _analyzePushupPose(pose);
        break;
      case 'lunge':
        _analyzeLungePose(pose);
        break;
    }
  }

  void _analyzeSquatPose(Pose pose) {
    final leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    final rightHip = pose.landmarks[PoseLandmarkType.rightHip];
    final leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
    final rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
    final leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
    final rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

    if ([
      leftHip,
      rightHip,
      leftKnee,
      rightKnee,
      leftAnkle,
      rightAnkle,
      leftShoulder,
      rightShoulder
    ].contains(null)) {
      _feedbackText = "일부 관절 인식 불가";
      _feedbackColor = Colors.red;
      setState(() {});
      return;
    }

    // 각도 계산
    _leftKneeAngle = _calculateAngle(leftHip!, leftKnee!, leftAnkle!);
    _rightKneeAngle = _calculateAngle(rightHip!, rightKnee!, rightAnkle!);
    _leftHipAngle = _calculateAngle(leftShoulder!, leftHip, leftKnee);
    _rightHipAngle = _calculateAngle(rightShoulder!, rightHip, rightKnee);
    _torsoAngle = _calculateAngle(leftShoulder, leftHip, rightHip);

    // 자세 분석 및 피드백
    _provideFeedback(
      torsoAngle: _torsoAngle,
      kneeAngle: _leftKneeAngle,
      hipAngle: _leftHipAngle,
      armAngle: null,
    );

    // 스쿼트 카운트
    const downThreshold = 100.0;
    const upThreshold = 150.0;

    if (!_isSquatting && _leftKneeAngle < downThreshold) {
      _isSquatting = true;
      setState(() {});
    } else if (_isSquatting && _leftKneeAngle > upThreshold) {
      _isSquatting = false;
      _reps += 1;
      _playSound('assets/audio/lunge_foot_spacing.mp3');
      _feedbackText = "⬆️ 좋아요! $_reps 회 완료";
      _feedbackColor = Colors.greenAccent;
      setState(() {});
    }
  }

  void _analyzePushupPose(Pose pose) {
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
    final leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
    final rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
    final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
    final rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
    final leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    final rightHip = pose.landmarks[PoseLandmarkType.rightHip];

    if ([
      leftShoulder,
      rightShoulder,
      leftElbow,
      rightElbow,
      leftWrist,
      rightWrist,
      leftHip,
      rightHip
    ].contains(null)) {
      _feedbackText = "일부 관절 인식 불가";
      _feedbackColor = Colors.red;
      setState(() {});
      return;
    }

    // 각도 계산
    final armAngle = _calculateAngle(leftShoulder!, leftElbow!, leftWrist!);
    _torsoAngle = _calculateAngle(leftShoulder, leftHip!, rightHip!);

    // 자세 분석 및 피드백
    _provideFeedback(
      torsoAngle: _torsoAngle,
      kneeAngle: armAngle,
      hipAngle: null,
      armAngle: armAngle,
    );

    // 푸시업 카운트
    const downThreshold = 90.0;
    const upThreshold = 160.0;

    if (!_isSquatting && armAngle < downThreshold) {
      _isSquatting = true;
      setState(() {});
    } else if (_isSquatting && armAngle > upThreshold) {
      _isSquatting = false;
      _reps += 1;
      _playSound('assets/audio/pushup_up.mp3');
      _feedbackText = "⬆️ 좋아요! $_reps 회 완료";
      _feedbackColor = Colors.greenAccent;
      setState(() {});
    }
  }

  void _analyzeLungePose(Pose pose) {
    final leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    final rightHip = pose.landmarks[PoseLandmarkType.rightHip];
    final leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
    final rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
    final leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
    final rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

    if ([
      leftHip,
      rightHip,
      leftKnee,
      rightKnee,
      leftAnkle,
      rightAnkle,
      leftShoulder,
      rightShoulder
    ].contains(null)) {
      _feedbackText = "일부 관절 인식 불가";
      _feedbackColor = Colors.red;
      setState(() {});
      return;
    }

    // 각도 계산
    _leftKneeAngle = _calculateAngle(leftHip!, leftKnee!, leftAnkle!);
    _rightKneeAngle = _calculateAngle(rightHip!, rightKnee!, rightAnkle!);
    _torsoAngle = _calculateAngle(leftShoulder!, leftHip, rightHip);

    // 자세 분석 및 피드백
    _provideFeedback(
      torsoAngle: _torsoAngle,
      kneeAngle: _leftKneeAngle,
      hipAngle: _rightKneeAngle,
      armAngle: null,
    );

    // 런지 카운트
    const downThreshold = 90.0;
    const upThreshold = 150.0;

    if (!_isSquatting && _leftKneeAngle < downThreshold) {
      _isSquatting = true;
      setState(() {});
    } else if (_isSquatting && _leftKneeAngle > upThreshold) {
      _isSquatting = false;
      _reps += 1;
      _playSound('assets/audio/lunge_up.mp3');
      _feedbackText = "⬆️ 좋아요! $_reps 회 완료";
      _feedbackColor = Colors.greenAccent;
      setState(() {});
    }
  }

  Future<void> _provideFeedback({
    required double torsoAngle,
    required double kneeAngle,
    required double? hipAngle,
    required double? armAngle,
  }) async {
    final now = DateTime.now();
    if (_lastAlertTime == null ||
        now.difference(_lastAlertTime!).inSeconds > 5) {
      _lastAlertTime = now;
      _feedbackText = "운동 분석 중...";
      _feedbackColor = Colors.white;
      await _audioPlayer.stop();
      await _audioPlayer.setAsset('assets/audio/excessive_arch_1.mp3');
      await _audioPlayer.play();
      setState(() {});
    }
  }

  double _calculateAngle(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
    final ab = Offset(a.x - b.x, a.y - b.y);
    final cb = Offset(c.x - b.x, c.y - b.y);
    final dotProduct = ab.dx * cb.dx + ab.dy * cb.dy;
    final magnitude = ab.distance * cb.distance;
    final angleRad = math.acos(dotProduct / magnitude);
    return angleRad * 180 / math.pi;
  }

  double _calculatePoseAccuracy(List<Pose> poses) {
    return poses.first.landmarks.length / 33.0;
  }

  Future<void> _saveExerciseRecord({
    required String exerciseName,
    required int count,
    required double accuracy,
    required double calories,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(Duration(days: 1));
    final timeStr = DateFormat('HH:mm').format(now);
    final dayOfWeek = DateFormat('EEEE', 'ko_KR').format(now);

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('exerciseRecords');

    final existing = await ref
        .where('exerciseName', isEqualTo: exerciseName)
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: endOfDay)
        .get();

    if (existing.docs.isNotEmpty) {
      final doc = existing.docs.first;
      final data = doc.data();
      await doc.reference.update({
        'count': (data['count'] ?? 0) + count,
        'calories': (data['calories'] ?? 0.0) + calories,
        'accuracy': ((data['accuracy'] ?? 0.0) + accuracy) / 2,
        'timeStr': timeStr,
        'date': now,
      });
    } else {
      await ref.add({
        'exerciseName': exerciseName,
        'count': count,
        'accuracy': accuracy,
        'calories': calories,
        'dayOfWeek': dayOfWeek,
        'date': now,
        'timeStr': timeStr,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  void _playSound(String soundPath) async {
    await _audioPlayer.stop();
    await _audioPlayer.setAsset(soundPath);
    await _audioPlayer.play();
  }
}
