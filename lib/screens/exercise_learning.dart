import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ExerciseLearningScreen extends StatefulWidget {
  const ExerciseLearningScreen({super.key});

  @override
  State<ExerciseLearningScreen> createState() => _ExerciseLearningScreenState();
}

class _ExerciseLearningScreenState extends State<ExerciseLearningScreen> {
  late final WebViewController _squatController;
  late final WebViewController _pushupController;
  late final WebViewController _lungeController;

  final Uri squatUrl = Uri.parse('https://www.youtube.com/shorts/RGb4Di4Dk_k');
  final Uri pushupUrl = Uri.parse('https://www.youtube.com/shorts/IGA9a1RVScU');
  final Uri lungeUrl = Uri.parse('https://www.youtube.com/shorts/MkBlqco3_NI');

  @override
  void initState() {
    super.initState();
    _squatController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(squatUrl);

    _pushupController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(pushupUrl);

    _lungeController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(lungeUrl);
  }

  Widget buildSection(String title, WebViewController controller, Uri url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(height: 1),
        SizedBox(
          height: 300,
          child: WebViewWidget(controller: controller),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 24.0),
          child: GestureDetector(
            onTap: () async {
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            child: const Text(
              '해당 영상 바로가기',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 배우기'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildSection('스쿼트', _squatController, squatUrl),
            buildSection('푸쉬업', _pushupController, pushupUrl),
            buildSection('런지', _lungeController, lungeUrl),
          ],
        ),
      ),
    );
  }
}