import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/favorite_provider.dart';

class FavoriteScreen extends StatelessWidget {
  final List<String> imageList = [
    "soldtheworlds.png",
    "zotusstore.png",
    "martin2k.png",
    "offcollector.png",
  ];

  final List<String> productTitles = [
    "Soldtheworlds",
    "Zotus Store",
    "Martin2k",
    "Offcollector",
  ];

  final List<String> description_home = [
    "Soldtheworlds ร้านเสื้อวินเทจ 80s-90s และมือสองคุณภาพดี...",
    "ZotusStore ร้านเสื้อวินเทจและมือสอง...",
    "Martin2k ร้านเสื้อมวยปล้ำวินเทจ...",
    "Offcollector ร้านเสื้อผ้าวินเทจ...",
  ];

  final List<String> reviews = ["590", "899", "1000", "9999"];

  @override
  Widget build(BuildContext context) {
    final favoriteIndexes = context.watch<FavoriteProvider>().favoriteIndexes;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites ")),
      body:
          favoriteIndexes.isEmpty
              ? const Center(child: Text("There's nothing like!!!"))
              : ListView.builder(
                itemCount: favoriteIndexes.length,
                itemBuilder: (context, index) {
                  final i = favoriteIndexes[index];
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/${imageList[i]}",
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productTitles[i],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    description_home[i],
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text("(${reviews[i]})"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// ❤️ ปุ่มหัวใจมุมขวาล่าง
                      Positioned(
                        bottom: 18,
                        right: 20,
                        child: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            context.read<FavoriteProvider>().toggleFavorite(i);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
    );
  }
}
