import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProteinScreen extends StatelessWidget {
  final List<Map<String, String>> brands = [
    {"name": "옵티멈 뉴트리션", "url": "https://www.optimumnutrition.co.kr/product/list.html?cate_no=123"},
    {"name": "웨이테크", "url": "https://wheytech.co.kr/product/list.html?cate_no=24"},
    {"name": "후디스", "url": "https://foodismall.com/product/list.html?cate_no=621"},
    {"name": "칼로바이", "url": "https://www.calobye.com/diet_shake_html.php"},
    {"name": "밀팜", "url": "https://mealfarm.co.kr/category/%EA%B3%A0%EB%A6%B4%EB%9D%BC%ED%91%B8%EB%93%9C/24/"},
    {"name": "bsn", "url": "https://bsn.co.kr/product/list.html?cate_no=123"},
    {"name": "삼대오백", "url": "https://samdae500.com/product/list.html?cate_no=248"},
  ];

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        debugPrint("URL launch failed: $url");
      }
    } catch (e) {
      debugPrint('Exception during URL launch: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('브랜드 선택'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          return ListTile(
            title: Text(brand["name"]!),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _launchURL(brand["url"]!),
          );
        },
      ),
    );
  }
}
