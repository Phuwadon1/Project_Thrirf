import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  final List<String> productTitles; // รับ product titles จาก HomeScreen
  final List<bool> isFavorite; // รับสถานะ favorites จาก HomeScreen

  const FavoriteScreen({
    required this.productTitles,
    required this.isFavorite,
    super.key, required List favoriteProducts,
  });

  @override
  Widget build(BuildContext context) {
    // กรองลิสต์ productTitles ตามสถานะ isFavorite
    final List<String> favoriteProducts =
        productTitles
            .asMap()
            .entries
            .where(
              (entry) => isFavorite[entry.key],
            ) // กรองโดยใช้สถานะ isFavorite
            .map((entry) => entry.value) // เอาชื่อผลิตภัณฑ์ออกมา
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite')),
      body:
          favoriteProducts.isEmpty
              ? const Center(child: Text('ยังไม่มีรายการที่ถูกใจ'))
              : ListView.builder(
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(favoriteProducts[index]));
                },
              ),
    );
  }
}