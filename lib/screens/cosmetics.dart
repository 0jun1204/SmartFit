import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CosmeticsScreen extends StatelessWidget {
  final List<Map<String, String>> brands = [
    {"name": "미샤", "url": "https://www.ableshop.kr/product/goods/view-goods?goodsId=BO00084693"},
    {"name": "코스노리", "url": "https://graceclub.com/product/%EC%98%AC%EC%9B%A8%EC%9D%B4%EC%A6%88-%EC%8A%AC%EB%A6%BC-%ED%95%8F-%EC%85%80%EB%A3%B0%EB%9D%BC%EC%9D%B4%ED%8A%B8-%EB%B0%94%EB%94%94%EC%A0%A4-%EC%9E%84%EC%83%81%EC%99%84%EB%A3%8C/185/category/53/display/1/"},
    {"name": "유라인코스메틱", "url": "https://ulinecosmetic.com/product/list.html?cate_no=26"},
    {"name": "프로피에스", "url": "https://profis.co.kr/product/list.html?cate_no=175"},
    {"name": "릴리이브", "url": "https://lilyeve.kr/category/%EC%A3%BC%EB%A6%84%C2%B7%ED%83%84%EB%A0%A5/29/"},
    {"name": "엘리메르", "url": "https://www.elimerek.com/shop/shopdetail.html?branduid=3549577&xcode=003&mcode=005&scode=&type=Y&sort=regdate&cur_code=003005&search=&GfDT=bWx3UQ%3D%3D"},
    {"name": "슈엘로", "url": "https://smartstore.naver.com/bigselect/products/9160306425"},
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
