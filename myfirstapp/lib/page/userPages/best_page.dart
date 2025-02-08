import 'package:flutter/material.dart';
import 'package:myfirstapp/components/featured_app_bar.dart'; // ใช้ FeaturedAppBar เหมือนกัน
import '../../models/item.dart'; // Import Shirt model
import '../../models/stock.dart'; // Import Stock model
import 'package:myfirstapp/components/item_tile.dart'; // ใช้ ItemTile สำหรับแสดงสินค้า

class BestSellPage extends StatefulWidget {
  const BestSellPage({super.key});

  @override
  State<BestSellPage> createState() => _BestSellPageState();
}

class _BestSellPageState extends State<BestSellPage> {
  final Stock stock = Stock(); // สร้าง instance ของ Stock

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
              // หัวข้อ "Best Sell"
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Text(
                  'Best Sell',
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ),
              // GridView สำหรับแสดงสินค้า
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: SizedBox(
                  height: 500, // กำหนดความสูงสำหรับ GridView
                  child: GridView.builder(
                    scrollDirection: Axis.vertical, // แสดงรายการในแนวตั้ง
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // แสดง 2 ชิ้นต่อแถว
                      mainAxisSpacing: 2, // ระยะห่างแนวตั้งระหว่างแถว
                      crossAxisSpacing: 10, // ระยะห่างแนวนอนระหว่างการ์ด
                      childAspectRatio: 2 / 3, // อัตราส่วนการ์ดสินค้า
                    ),
                    itemCount: stock.bestSellItems.length, // ใช้ข้อมูล bestSellItems
                    itemBuilder: (context, index) {
                      final Shirt shirt = stock.bestSellItems[index]; // ดึงข้อมูลสินค้าขายดี
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
