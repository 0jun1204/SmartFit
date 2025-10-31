import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChickenScreen extends StatelessWidget {
  final List<Map<String, String>> brands = [
    {"name": "아임닭", "url": "https://www.imdak.com/product/list.html?cate_no=275"},
    {"name": "하림", "url": "https://harimmall.com/product/list2.html?cate_no=263&sort_method=6#Product_ListMenu"},
    {"name": "허닭", "url": "http://www.heodak.com/shop/shopbrand.html?type=N&xcode=016&mcode=006"},
    {"name": "홀리닭", "url": "https://smartstore.naver.com/holydak/best?cp=1"},
    {"name": "맛있닭", "url": "https://masitdak.com/shop/list2.php?ca=2020"},
    {"name": "바르닭", "url": "https://barudak.co.kr/product/list.html?cate_no=144"},
    {"name": "채우닭", "url": "https://chaewoodak.co.kr/product/list_best.html?cate_no=27"},
    {"name": "위하닭", "url": "https://wehadak.com/product/list.html?cate_no=105"},
    {"name": "굽네", "url": "https://www.goobnemall.com/shop/shopbrand.html?type=X&xcode=003"},
    {"name": "BHC", "url": "https://bhcmall.co.kr/goods/category.asp?cate=374"},
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
