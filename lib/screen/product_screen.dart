import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';


class ProductScreen extends StatefulWidget {
  // 1. เพิ่มตัวแปรเพื่อรับข้อมูล
  final String productTitle;
  final String productSubtitle; // เพิ่ม Subtitle ถ้าต้องการ
  final String description_detail;
  final String qrDataString;
  final List<String> imageAssets; // รับ List รูปภาพ (ถ้าต้องการให้ต่างกัน)

  // 2. แก้ไข Constructor ให้รับค่าเหล่านี้
  const ProductScreen({
    super.key,
    required this.productTitle,
    required this.productSubtitle,
    required this.description_detail,
    required this.qrDataString,
    required this.imageAssets, required String title, required String subtitle, required String image, required String review, required String reviews, // รับ List รูปภาพ
  });

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // ลบ List ที่ hardcode ออก (ยกเว้น assets ถ้าจะใช้ชุดเดิมทุกครั้ง)
  // List<String> assets = ["font.png", ...]; // << ถ้าจะใช้ชุดเดิมตลอด ก็คงไว้
  // List<String> _qrData = [...]; // << ลบออก ใช้ค่าจาก widget.qrDataString แทน

  bool _isDetailsVisible = false;

  void _toggleDetails() {
    setState(() {
      _isDetailsVisible = !_isDetailsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // เพิ่ม AppBar กลับไปหน้า Home
      appBar: AppBar(
        title: Text(widget.productTitle), // ใช้ Title ที่รับมา
        backgroundColor: Colors.white, // หรือสีที่ต้องการ
        elevation: 1,
        foregroundColor: Colors.black, // สีไอคอนและ Title บน AppBar
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                  child: FanCarouselImageSlider.sliderType1(
                    sliderHeight: 430,
                    autoPlay: true,
                    // 3. ใช้ List รูปภาพที่รับมา
                    imagesLink: widget.imageAssets, // ใช้ List ที่ส่งมา
                    isAssets: true,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        // 3. ใช้ Title ที่รับมา
                        Text(
                          widget.productTitle,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 5),
                        // 3. ใช้ Subtitle ที่รับมา
                        Text(
                          widget.productSubtitle, // ใช้ Subtitle ที่ส่งมา
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  // 3. ใช้ Description ที่รับมา
                  child: Text(
                    widget.description_detail, // ใช้ Description ที่ส่งมา
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _toggleDetails,
                  child: Text(
                    _isDetailsVisible ? 'ปิดรายละเอียด' : 'รายละเอียดเพิ่มเติม',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                if (_isDetailsVisible)
                  Column(
                    children: [
                      SizedBox(height: 20),
                      QrImageView(
                        // 3. ใช้ QR Data ที่รับมา
                        data: widget.qrDataString, // ใช้ QR Data ที่ส่งมา
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                      SizedBox(height: 20),
                      Text("สแกน QR Code นี้"),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}