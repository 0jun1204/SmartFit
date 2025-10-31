import 'package:flutter/material.dart';

class HealthDashboardScreen extends StatefulWidget {
  const HealthDashboardScreen({super.key});

  @override
  State<HealthDashboardScreen> createState() => _HealthDashboardScreenState();
}

class _HealthDashboardScreenState extends State<HealthDashboardScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();

  String _gender = '남성';
  double? _bmi;
  double? _bmr;

  void _calculate() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    final age = int.tryParse(_ageController.text);

    if (height != null && weight != null && age != null) {
      final heightInMeters = height / 100;
      _bmi = weight / (heightInMeters * heightInMeters);

      if (_gender == '남성') {
        _bmr = 66.47 + (13.75 * weight) + (5.003 * height) - (6.755 * age);
      } else {
        _bmr = 655.1 + (9.563 * weight) + (1.850 * height) - (4.676 * age);
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('건강 대시보드')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text('환영합니다!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '키 (cm)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '몸무게 (kg)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '나이', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("남성"),
                    value: '남성',
                    groupValue: _gender,
                    onChanged: (value) => setState(() => _gender = value!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("여성"),
                    value: '여성',
                    groupValue: _gender,
                    onChanged: (value) => setState(() => _gender = value!),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text("BMI & BMR 계산하기"),
            ),
            const SizedBox(height: 20),
            if (_bmi != null && _bmr != null) ...[
              Text("BMI: ${_bmi!.toStringAsFixed(1)}"),
              Text("BMR: ${_bmr!.toStringAsFixed(0)} kcal/day"),
            ]
          ],
        ),
      ),
    );
  }
}
