import 'package:flutter/material.dart';
// import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
// import 'package:qr_flutter/qr_flutter.dart';
import 'product_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> productTitles = [
    "Soldtheworlds",
    "Zotus Store",
    "Martin2k",
    "Offcollector",
  ];

  List<String> productSubtitles = [
    "Vintage T-shirt Store",
    "Vintage & Secondhand Store",
    "Vintage Wrestling T-shirts",
    "Vintage Clothing Collector",
  ];

  List<String> imageList = [
    "soldtheworlds.png",
    "zotusstore.png",
    "martin2k.png",
    "offcollector.png",
  ];

  List<List<String>> detailImageAssets = [
    ["font.png", "in.jpg", "shirt.png", "raptee.jpg"],
    ["font1.jpg", "custumer.jpg", "shirt1.jpg", "p_tus.jpg"],
    ["dx.jpg", "stonecold.jpg", "preview.jpg", "shawn.jpg"],
    ["custumer1.jpg", "promo.jpg", "shirt2.jpg", "mask.jpg"],
  ];

  List<String> descriptionDetail = [
    "เริ่มจากเปิดกระสอบเพื่อหาซื้อเสื้อวินเทจแล้วคัดเลือกเป็นชุดขาย เช่น เสื้อวงหรือการ์ตูน ซึ่งในช่วงนั้นยังไม่ค่อยมีคนรู้จักเสื้อแนวนี้ ตอนที่เริ่มเก็บเสื้อวินเทจก็เหมือนเปิดโลกใหม่ให้คนรู้จัก 'เสื้อวินเทจ' จริงๆ",
    "ZOTUS STORE เป็นเหมือนชุมชนที่พร้อมต้อนรับ และให้ความรู้แก่ทุกคนที่เดินเข้าไป รวมถึงรับซื้อของมือสองด้วย!",
    "เสื้อมวยปล้ำเป็นสินค้ายอดนิยมที่เริ่มแพร่หลายในยุค 80s-90s โดยมักเป็นสินค้าทางการของค่ายมวยปล้ำ เช่น WWE, WCW และ ECW ลวดลายมักสะท้อนตัวตนของนักมวยปล้ำชื่อดัง ทำให้กลายเป็นของสะสมในหมู่แฟน ๆ จนถึงปัจจุบัน",
    "เสื้อวินเทจตัวแรกที่ซื้อด้วยเงินของตัวเอง ไม่ใช่แค่เสื้อยืดเก่า ๆ แต่เป็นจุดเริ่มต้นของเส้นทางอาชีพและความหลงใหล ที่นำไปสู่ความรู้ ประสบการณ์ และชีวิตในวงการนี้อย่างแท้จริง",
  ];

  List<String> qrData = [
    "https://www.facebook.com/soldtheworldstore",
    "https://www.instagram.com/zotusstore/",
    "https://www.instagram.com/martin2k__/",
    "https://www.instagram.com/offcollector/",
  ];

  List<String> reviews = ["590", "899", "1000", "9999"];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<int> searchResults = List.generate(productTitles.length, (index) => index)
        .where((index) => productTitles[index].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                height: 50,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.black54),
                    border: InputBorder.none,
                    hintText: "Find Your Thrift Store",
                    hintStyle: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    int i = searchResults[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Image.asset(imageList[i], width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(productTitles[i], style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(productSubtitles[i]),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                SizedBox(width: 5),
                                Text(reviews[i]),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.height * 0.8,
                                child: ProductScreen(
                                  productTitle: productTitles[i],
                                  productSubtitle: productSubtitles[i],
                                  description_detail: descriptionDetail[i],
                                  qrDataString: qrData[i],
                                  imageAssets: detailImageAssets[i],
                                  title: productTitles[i],
                                  subtitle: productSubtitles[i],
                                  image: imageList[i],
                                  review: reviews[i],
                                  reviews: reviews[i],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}