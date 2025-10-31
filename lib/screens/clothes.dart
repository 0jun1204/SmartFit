import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClothesScreen extends StatelessWidget {
  final List<Map<String, String>> brands = [
    {"name": "나이키", "url": "https://www.nike.com/kr/w/training-apparel-58jtoz6ymx6"},
    {"name": "아디다스", "url": "https://www.adidas.co.kr/gym_training"},
    {"name": "언더아머", "url": "https://www.underarmour.co.kr/ko-kr/c/ec-only/sports/training/?start=12&sz=12"},
    {"name": "뉴발란스", "url": "https://www.nbkorea.com/product/productList.action?cateGrpCode=250110&cIdx=1883"},
    {"name": "블랙몬스터핏", "url": "https://black-monster.co.kr/product/list.html?cate_no=254"},
    {"name": "디스커버리 익스페디션", "url": "https://www.discovery-expedition.com/display/DXMB01B04"},
    {"name": "젝시믹스", "url": "https://www.xexymix.com/shop/shopbrand.html?xcode=006&mcode=005&type=Y"},
    {"name": "에이치덱스", "url": "https://hdex.co.kr/index.html"},
    {"name": "데상트", "url": "https://shop.descentekorea.co.kr/DESCENTE/Category/016802000"},
    {"name": "푸마", "url": "https://kr.puma.com/kr/ko/%EC%8A%A4%ED%8F%AC%EC%B8%A0/%EB%9F%AC%EB%8B%9D?srule=New%20Arrivals&prefv1=%EC%9D%98%EB%A5%98&prefn1=productdivName&pmpt=discounted&pmid=nosales-category-promotion-KR"},
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
