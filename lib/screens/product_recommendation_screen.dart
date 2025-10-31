import 'package:flutter/material.dart';
import 'clothes.dart';
import 'chicken.dart';
import 'protein.dart';
import 'equipment.dart';
import 'diet.dart';
import 'cosmetics.dart';

class ProductRecommendationScreen extends StatelessWidget {
  const ProductRecommendationScreen({super.key});

  final List<Map<String, String>> products = const [
    {"title": "의류", "image": "assets/images/clothes.jpg"},
    {"title": "닭가슴살", "image": "assets/images/chicken.jpg"},
    {"title": "프로틴", "image": "assets/images/protein.jpg"},
    {"title": "운동장비", "image": "assets/images/equipment.jpg"},
    {"title": "보조식품", "image": "assets/images/diet.jpg"},
    {"title": "화장품", "image": "assets/images/cosmetics.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('제품 추천'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                if (product['title'] == '의류') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClothesScreen()),
                  );
                } else if (product['title'] == '닭가슴살') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChickenScreen()),
                  );
                } else if (product['title'] == '프로틴') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProteinScreen()),
                  );
                } else if (product['title'] == '운동장비') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EquipmentScreen()),
                  );
                } else if (product['title'] == '보조식품') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DietScreen()),
                  );
                } else if (product['title'] == '화장품') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CosmeticsScreen()),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.asset(
                          product['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          product['title']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
