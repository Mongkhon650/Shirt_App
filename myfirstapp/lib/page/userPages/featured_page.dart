import 'package:flutter/material.dart';
import 'package:myfirstapp/components/featured_app_bar.dart';
import '../../models/item.dart';
import '../../models/stock.dart';
import 'package:myfirstapp/components/item_tile.dart';

class FeaturedPage extends StatefulWidget {
  const FeaturedPage({super.key});

  @override
  State<FeaturedPage> createState() => _FeaturedPageState();
}

class _FeaturedPageState extends State<FeaturedPage> {
  // สร้างตัวแปร stock ขึ้นมา
  final Stock stock = Stock();  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // appbar
          FeaturedAppBar(),
        ],
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10 , left: 20),
                // text
                child: Text(
                  'Featured',
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: SizedBox(
                  height: 500, // เพิ่มความสูงเพื่อรองรับหลายแถว
                  child: GridView.builder(
                    scrollDirection: Axis.vertical, // แสดงรายการในแนวตั้ง
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // แสดงสองชิ้นต่อหนึ่งแถว
                      mainAxisSpacing: 2, // ระยะห่างแนวตั้งระหว่างชิ้น
                      crossAxisSpacing: 10, // ระยะห่างแนวนอนระหว่างชิ้น
                      childAspectRatio: 2/3, // กำหนดอัตราส่วนความสูงและความกว้างของแต่ละชิ้น
                    ),
                    itemCount: stock.featuredItems.length,  // ใช้ stock ในที่นี้
                    itemBuilder: (context, index) {
                      Shirt shirt = stock.featuredItems[index];  // ดึงข้อมูลจาก stock
                      return ItemTile(shirt: shirt); // แสดงข้อมูลสินค้าผ่าน ItemTile
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
