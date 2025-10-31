import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'health_dashboard_screen.dart';
import '../exercise_selection_screen.dart';
import 'workout_history_screen.dart';
import 'posture_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const HealthDashboardScreen(),
    const Placeholder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 요약'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('로그아웃되었습니다')),
                  );
                  Navigator.pushReplacementNamed(context, '/');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('로그아웃 실패: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: ''),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildCard(context, '운동 분석', Icons.fitness_center, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExerciseSelectionScreen()),
            );
          }),
          _buildCard(context, '근육 부위', Icons.accessibility_new, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PostureScreen(selectedExercise: ExerciseType.squat),
              ),
            );
          }),
          _buildCard(context, '과거 이력', Icons.history, () {
            Navigator.pushNamed(context, '/workout-history');
          }),
          _buildCard(context, '제품 추천', Icons.shopping_cart, () {
            Navigator.pushNamed(context, '/product-recommendation');
          }),
          _buildCard(context, '운동 배우기', Icons.menu_book, () {
            Navigator.pushNamed(context, '/exercise-learning');
          }),

        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}