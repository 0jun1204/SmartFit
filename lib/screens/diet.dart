import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DietScreen extends StatelessWidget {
  final List<Map<String, String>> brands = [
    {"name": "푸드올로지", "url": "https://food-ology.co.kr/product/list.html?cate_no=26"},
    {"name": "스키니랩", "url": "https://www.skinnylab.co.kr/shop/diet/cissus"},
    {"name": "포뉴", "url": "https://www.ponu.co.kr/m/product_list.html?xcode=001&type=M&mcode=005&viewtype=list#enp_mbris"},
    {"name": "grn", "url": "https://grnplus.co.kr/category/%EB%8B%A4%EC%9D%B4%EC%96%B4%ED%8A%B8/49/"},
    {"name": "헬스헬퍼", "url": "https://healthhelper.kr/category/%EB%B2%A0%EC%8A%A4%ED%8A%B8/137/"},
    {"name": "오늘부터", "url": "https://fromtoday.kr/product/list.html?cate_no=24"},
    {"name": "세리박스", "url": "https://www.serybox.com/shop/big_section.php?cno1=1005"},
    {"name": "익스트림", "url": "https://exxxtreme.co.kr/product/list.html?cate_no=60"},
    {"name": "종근당건강", "url": "https://ckdhcmall.co.kr/categoryProductList.do?lvl=3&categoryCode=B001001009"},
    {"name": "뉴오리진", "url": "https://www.neworigin.co.kr/goods/goods_list.php?cateCd=024005005"},
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
