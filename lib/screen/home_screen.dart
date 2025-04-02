import 'package:flutter/material.dart';
import 'product_screen.dart'; // <-- เพิ่ม import
import 'package:favorite_button/favorite_button.dart';


class HomeScreen extends StatelessWidget {
  List imageList = [
    "soldtheworlds.png",
    "zotusstore.png",
    "martin2k.png",
    "offcollector.png",
  ];

  // สมมติว่านี่คือ List รูปภาพ *ทั้งหมด* ของแต่ละร้าน (ถ้าต้องการให้ต่างกัน)
  // ถ้าจะใช้ชุดเดิมใน ProductScreen ตลอด ก็ไม่ต้องมีตัวแปรนี้
  List<List<String>> detailImageAssets = [
    ["font.png", "in.jpg", "shirt.png", "raptee.jpg"], // รูปของ Soldtheworlds
    [
      "font1.jpg",
      "custumer.jpg",
      "shirt1.jpg",
      "p_tus.jpg",
    ], // รูปของ Zotus Store
    ["dx.jpg", "stonecold.jpg", "preview.jpg", "shawn.jpg"], // รูปของ Martin2k
    [
      "custumer1.jpg",
      "promo.jpg",
      "shirt2.jpg",
      "mask.jpg",
    ], // รูปของ Offcollector
  ];

  List productTitles = [
    "Soldtheworlds",
    "Zotus Store",
    "Martin2k",
    "Offcollector",
  ];

  // เพิ่ม Subtitle ถ้าต้องการ
  List productSubtitles = [
    "Vintage T-shirt Store",
    "Vintage & Secondhand Store",
    "Vintage Wrestling T-shirts",
    "Vintage Clothing Collector",
  ];

  List description_home = [
    "Soldtheworlds ร้านเสื้อวินเทจ 80s-90s และมือสองคุณภาพดี ที่ตลาดรถไฟศรีนครินทร์และออนไลน์",
    "ZotusStore ร้านเสื้อวินเทจและมือสอง ที่ตลาดรถไฟศรีนครินทร์และออนไลน์",
    "Martin2k ร้านเสื้อมวยปล้ำวินเทจ เรานำเสนอเสื้อผ้าที่สะท้อนยุคทองของมวยปล้ำในอดีต ด้วยดีไซน์กราฟิกและโลโก้จากนักมวยปล้ำชื่อดังในยุค 80s-90s",
    "Offcollector ร้านเสื้อผ้าวินเทจและมือสองคุณภาพดี เชี่ยวชาญในการคัดสรรและตรวจสอบความแท้ของสินค้า",
  ];

  List description_detail = [
    "เริ่มจากเปิดกระสอบเพื่อหาซื้อเสื้อวินเทจแล้วคัดเลือกเป็นชุดขาย เช่น เสื้อวงหรือการ์ตูน ซึ่งในช่วงนั้นยังไม่ค่อยมีคนรู้จักเสื้อแนวนี้ ตอนที่เริ่มเก็บเสื้อวินเทจก็เหมือนเปิดโลกใหม่ให้คนรู้จัก 'เสื้อวินเทจ' จริงๆ",
    "ZOTUS STORE เป็นเหมือนชุมชนที่พร้อมต้อนรับ และให้ความรู้แก่ทุกคนที่เดินเข้าไป รวมถึงรับซื้อของมือสองด้วย!",
    "เสื้อมวยปล้ำเป็นสินค้ายอดนิยมที่เริ่มแพร่หลายในยุค 80s-90s โดยมักเป็นสินค้าทางการของค่ายมวยปล้ำ เช่น WWE, WCW และ ECW ลวดลายมักสะท้อนตัวตนของนักมวยปล้ำชื่อดัง ทำให้กลายเป็นของสะสมในหมู่แฟน ๆ จนถึงปัจจุบัน",
    "เสื้อวินเทจตัวแรกที่ซื้อด้วยเงินของตัวเอง ไม่ใช่แค่เสื้อยืดเก่า ๆ แต่เป็นจุดเริ่มต้นของเส้นทางอาชีพและความหลงใหล ที่นำไปสู่ความรู้ ประสบการณ์ และชีวิตในวงการนี้อย่างแท้จริง",
  ];
  // เพิ่ม List QR Data (ต้องมีจำนวนเท่ากับ List อื่นๆ)
  List<String> _qrData = [
    "https://www.facebook.com/soldtheworldstore",
    "https://www.instagram.com/zotusstore/",
    "https://www.instagram.com/martin2k__/",
    "https://www.instagram.com/offcollector/",
  ];

  List reviews = ["590", "899", "1000", "9999"];

  @override
  Widget build(BuildContext context) {
    // --- ส่วนบนเหมือนเดิม ---
    return Scaffold(
      backgroundColor: Colors.white, // เปลี่ยนพื้นหลังถ้าต้องการ
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Search Bar Row --- (เหมือนเดิม)
                SizedBox(height: 20), // ลดระยะห่าง
                Container(
                  // --- Banner ---
                  height: 150, // ลดขนาด Banner
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    // color: Colors.blueAccent, // หรือสีอื่น
                    borderRadius: BorderRadius.circular(15), // ปรับมุม
                    image: DecorationImage(
                      // ใช้ DecorationImage แทน Image.asset
                      image: AssetImage(
                        "assets/ThriftPoint_cover_black.png",
                      ), // ต้องมี assets/ นำหน้าถ้าอยู่ใน folder assets
                      fit: BoxFit.cover,
                    ),
                  ),
                  //  child: Image.asset(
                  //    "assets/ThriftPoint_cover_black.png", // ตรวจสอบว่า path ถูกต้อง และอยู่ใน pubspec.yaml
                  //    fit: BoxFit.cover, // อาจจะเพิ่ม fit
                  //   ),
                ),
                // SizedBox(height: 20),
                // // --- Tabs --- (เหมือนเดิม)
                // SizedBox(
                //   height: 40, // ลดความสูงเล็กน้อย
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemCount: tabs.length,
                //     itemBuilder: (context, index) {
                //       return Container(
                //         // ใช้คำว่า return เฉยๆ
                //         // height: 40, // เอาออกได้เพราะ SizedBox กำหนดแล้ว
                //         margin: EdgeInsets.only(
                //           right: 10,
                //         ), // ใช้ right margin อย่างเดียว
                //         padding: EdgeInsets.symmetric(
                //           horizontal: 20,
                //           vertical: 10,
                //         ), // ปรับ padding
                //         decoration: BoxDecoration(
                //           //  color: Colors.black12.withOpacity(0.05),
                //           color:
                //               index == 0
                //                   ? Colors.black
                //                   : Colors.grey[200], // Highlight อันแรก
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         child: Center(
                //           child: Text(
                //             // เอา FittedBox ออกได้ถ้าไม่ต้องการให้ scale ตามพื้นที่
                //             tabs[index],
                //             style: TextStyle(
                //               //  color: Colors.black,
                //               color:
                //                   index == 0
                //                       ? Colors.white
                //                       : Colors.black87, // สีตัวอักษร
                //               fontWeight: FontWeight.bold,
                //               fontSize: 14, // ปรับขนาด
                //             ),
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                SizedBox(height: 20),
                // --- Horizontal ListView ---
                Container(
                  // color: Colors.black12, // เอาสีพื้นหลังออก
                  height: 180,
                  child: ListView.builder(
                    itemCount: imageList.length,
                    scrollDirection: Axis.horizontal,
                    // shrinkWrap: true, // เอาออกได้ถ้า height ถูกกำหนดแล้ว
                    itemBuilder: (context, index) {
                      // *** ห่อด้วย InkWell ***
                      return InkWell(
                        onTap: () {
                          // *** Navigate ไป ProductScreen ***
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ProductScreen(
                                    productTitle: productTitles[index],
                                    productSubtitle:
                                        productSubtitles[index], // ส่ง Subtitle
                                    description_detail:
                                        description_detail[index],
                                    qrDataString:
                                        _qrData[index], // ส่ง QR Data ที่ตรงกัน
                                    imageAssets: detailImageAssets[index],
                                    title: '',
                                    subtitle: '',
                                    image: '',
                                    review: '',
                                    reviews: '', // ส่ง List รูปของร้านนั้นๆ
                                    // imageAssets: ["font.png", "in.jpg", "shirt.png"], // หรือส่ง List รูปภาพชุดเดิมไปก่อนก็ได้ ถ้ายังไม่มีข้อมูลแยก
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          width: 350,
                          margin: EdgeInsets.only(
                            right: 15,
                          ), // เปลี่ยน left เป็น right
                          padding: EdgeInsets.all(10), // เพิ่ม padding ภายใน
                          decoration: BoxDecoration(
                            // เพิ่มกรอบและเงาเล็กน้อย
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // --- รูปภาพ ---
                              SizedBox(
                                height: 160, // ปรับขนาดตาม padding
                                width: 160, // ปรับขนาดตาม padding
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      // ไม่ต้องมี InkWell ซ้อน
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        "assets/${imageList[index]}", // ใส่ assets/ ถ้าอยู่ใน folder
                                        fit: BoxFit.cover,
                                        height: 160,
                                        width: 160,
                                      ),
                                    ),
                                    Positioned(
                                      right: 8, // ปรับตำแหน่ง
                                      top: 8, // ปรับตำแหน่ง
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        child: Center(
                                          child: FavoriteButton(
                                            isFavorite: false,
                                            // iconDisabledColor: Colors.white,
                                            valueChanged: (isFavorite) {
                                              // ignore: avoid_print
                                              print(
                                                'Is Favorite : $isFavorite',
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // --- รายละเอียด ---
                              Expanded(
                                // ใช้ Expanded เพื่อให้ Column ใช้พื้นที่ที่เหลือ
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                  ), // เพิ่มระยะห่าง
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productTitles[index],
                                        style: TextStyle(
                                          fontSize: 16, // ปรับขนาด
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Expanded(
                                        // ให้ text ใช้พื้นที่เท่าที่เหลือในแนวตั้ง
                                        child: Text(
                                          description_home[index],
                                          maxLines: 4, // จำกัดจำนวนบรรทัด
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ), // ปรับขนาดและสี
                                        ),
                                      ),
                                      // SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 20, // ปรับขนาด
                                          ),
                                          SizedBox(width: 4), // เพิ่มระยะห่าง
                                          Text(
                                            '(${reviews[index]})',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ), // ปรับขนาดและสี
                                          ),
                                        ],
                                      ),
                                    ],
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

                SizedBox(height: 30),
                // --- Popular Stores Title ---
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Popular Stores",
                    style: TextStyle(
                      fontSize: 22, // ปรับขนาด
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15), // ลดระยะห่าง
                // --- GridView ---
                GridView.builder(
                  itemCount: productTitles.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75, // ปรับอัตราส่วน
                    crossAxisSpacing: 15, // เพิ่มระยะห่างแนวนอน
                    mainAxisSpacing: 15, // เพิ่มระยะห่างแนวตั้ง
                  ),
                  itemBuilder: (context, index) {
                    // *** ห่อด้วย InkWell ***
                    return InkWell(
                      onTap: () {
                        // *** Navigate ไป ProductScreen (เหมือนกับใน ListView) ***
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ProductScreen(
                                  productTitle: productTitles[index],
                                  productSubtitle: productSubtitles[index],
                                  description_detail: description_detail[index],
                                  qrDataString: _qrData[index],
                                  imageAssets: detailImageAssets[index],
                                  title: '',
                                  subtitle: '',
                                  image: '',
                                  review: '',
                                  reviews: '',
                                  // imageAssets: ["font.png", "in.jpg", "shirt.png"], // หรือ List เดิม
                                ),
                          ),
                        );
                      },
                      child: Container(
                        // Container นี้คือ card ของ GridView
                        decoration: BoxDecoration(
                          // เพิ่มกรอบให้ Grid Item
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          // Column เดิมของคุณ
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              // ให้รูปภาพยืดหยุ่น
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    // ไม่ต้องมี InkWell ซ้อน
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ), // ทำให้มุมบนโค้งตามกรอบ
                                    child: Image.asset(
                                      "assets/${imageList[index]}", // ใส่ assets/ ถ้าอยู่ใน folder
                                      // width: double.infinity, // ให้กว้างเต็ม Container
                                      height:
                                          double
                                              .infinity, // ให้สูงเต็มพื้นที่ Expanded
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  Positioned(
                                    // Favorite icon (เหมือนเดิม)
                                    right: 10,
                                    top: 10,
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      child: Center(
                                        child: FavoriteButton(
                                          isFavorite: false,
                                          // iconDisabledColor: Colors.white,
                                          valueChanged: (isFavorite) {
                                            // ignore: avoid_print
                                            print('Is Favorite : $isFavorite');
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              // เพิ่ม Padding ให้ข้อความข้างล่าง
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productTitles[index],
                                    style: TextStyle(
                                      fontSize: 16, // ปรับขนาด
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  SizedBox(height: 5),
                                  Row(
                                    // ดาว + รีวิว (เหมือนเดิม)
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 18,
                                      ), // ปรับขนาด
                                      SizedBox(width: 4),
                                      Text(
                                        '(${reviews[index]})',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
