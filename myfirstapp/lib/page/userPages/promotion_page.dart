import 'package:flutter/material.dart';
import 'package:myfirstapp/components/featured_app_bar.dart'; // ใช้ AppBar แบบเดียวกัน
import '../../models/item.dart'; // Import Shirt model
import '../../models/stock.dart'; // Import Stock model
import 'package:myfirstapp/components/item_tile.dart'; // ใช้ ItemTile สำหรับแสดงสินค้า

class PromotionPage extends StatefulWidget {
  const PromotionPage({super.key});

  @override
  State<PromotionPage> createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  // สร้างตัวแปร Stock
  final Stock stock = Stock();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // AppBar
          FeaturedAppBar(),
        ],
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                // หัวข้อ "Promotion"
                child: Text(
                  'Promotion',
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: SizedBox(
                  height: 500, // เพิ่มความสูงสำหรับ GridView
                  child: GridView.builder(
                    scrollDirection: Axis.vertical, // แสดงรายการในแนวตั้ง
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 ชิ้นต่อแถว
                      mainAxisSpacing: 2, // ระยะห่างระหว่างแถว
                      crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
                      childAspectRatio: 2 / 3, // สัดส่วนการ์ดสินค้า
                    ),
                    itemCount: stock.promotionItems.length, // ใช้รายการ promotionItems
                    itemBuilder: (context, index) {
                      Shirt shirt = stock.promotionItems[index]; // ดึงข้อมูลสินค้าโปรโมชั่น
                      return ItemTile(shirt: shirt); // ใช้ ItemTile แสดงสินค้า
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
