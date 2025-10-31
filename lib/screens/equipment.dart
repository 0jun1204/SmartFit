import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EquipmentScreen extends StatefulWidget {
  @override
  _EquipmentScreenState createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  final List<Map<String, dynamic>> categories = [
    {
      "title": "폼롤러",
      "products": [
        {"name": "트라택 EPP 폼롤러 원형", "url": "https://www.coupang.com/vp/products/45079633"},
        {"name": "코멧 EPP 폼롤러", "url": "https://www.coupang.com/vp/products/172134008"},
        {"name": "아리프 EVA 마블 폼롤러", "url": "https://www.coupang.com/vp/products/7563497247"},
      ],
    },
    {
      "title": "아령",
      "products": [
        {"name": "블루선 아령 덤벨 세트", "url": "https://www.coupang.com/vp/products/8068053169"},
        {"name": "아리프 네오프렌 아령", "url": "https://www.coupang.com/vp/products/6465787707"},
        {"name": "코멧 스포츠 고중량 아령", "url": "https://www.coupang.com/vp/products/7578389096"},
      ],
    },
    {
      "title": "푸쉬업바",
      "products": [
        {"name": "핏에이블 스틸 푸쉬업바", "url": "https://www.coupang.com/vp/products/7781136608"},
        {"name": "코멧 스포츠 푸쉬업바", "url": "https://www.coupang.com/vp/products/4705761543"},
        {"name": "나이키 푸쉬업 그립", "url": "https://www.coupang.com/vp/products/5911335692"},
      ],
    },
    {
      "title": "악력기",
      "products": [
        {"name": "하디로어 프리미엄 악력기", "url": "https://www.coupang.com/vp/products/4770622653"},
        {"name": "지디 그립 프로 악력기", "url": "https://www.coupang.com/vp/products/7144403308"},
        {"name": "강도조절 그립 카운터", "url": "https://www.coupang.com/vp/products/4846830941"},
      ],
    },
    {
      "title": "실내자전거",
      "products": [
        {"name": "스포틀러 엑스바이크", "url": "https://www.coupang.com/vp/products/7593599328"},
        {"name": "엑사이더 접이식 자전거", "url": "https://www.coupang.com/vp/products/261120257"},
        {"name": "코멧 스포츠 자전거", "url": "https://www.coupang.com/vp/products/6545696170"},
      ],
    },
    {
      "title": "요가매트",
      "products": [
        {"name": "트라택 요가매트", "url": "https://www.coupang.com/vp/products/6890690736"},
        {"name": "코멧 NBR 요가매트", "url": "https://www.coupang.com/vp/products/172134026"},
        {"name": "고무나라 TPE 요가매트", "url": "https://www.coupang.com/vp/products/64527390"},
      ],
    },
  ];

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("URL을 열 수 없습니다")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동기구'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ExpansionTile(
            title: Text(
              category["title"],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: [
              ...category["products"].map<Widget>((product) {
                return ListTile(
                  title: Text(product["name"]),
                  trailing: Icon(Icons.open_in_new),
                  onTap: () => _launchURL(product["url"]),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
