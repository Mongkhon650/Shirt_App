import 'package:flutter/material.dart';
import 'package:myfirstapp/components/userComponents/my_drawer_tile.dart';
import 'package:myfirstapp/page/userPages/cart_page.dart';
import 'package:myfirstapp/page/userPages/home_page.dart';
import 'package:myfirstapp/page/userPages/favorite_page.dart';
import 'package:myfirstapp/page/userPages/setting_page.dart';
import 'package:myfirstapp/page/welcome_page.dart';

import '../../page/userPages/my_orders.dart';

class MyDrawer extends StatelessWidget {
  final String userName; // รับ userName จาก HomePage

  const MyDrawer({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // จัดให้เริ่มต้นจากด้านบน
        crossAxisAlignment: CrossAxisAlignment.center, // จัดกึ่งกลางในแนวนอน
        children: [
          // ส่วนโปรไฟล์ผู้ใช้
          const SizedBox(height: 50), // ระยะห่างด้านบนสุด
          CircleAvatar(
            radius: 50, // ขนาดของวงกลม
            backgroundColor: Colors.grey.shade300,
            child: Text(
              userName[0].toUpperCase(), // ตัวอักษรแรกของชื่อ
              style: const TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10), // ระยะห่างระหว่างวงกลมกับชื่อ
          Text(
            userName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 20), // ระยะห่างระหว่างโปรไฟล์และเมนู

          // เมนูต่าง ๆ
          MyDrawerTile(
            text: "Home",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userName: userName)),
            ),
          ),
          MyDrawerTile(
            text: "MyCart",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            ),
          ),
          MyDrawerTile(
            text: "Favorite",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritePage()),
            ),
          ),
          MyDrawerTile(
            text: "My Orders",
            onTap: ()  => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyOrdersPage()),
            ),
          ),

          MyDrawerTile(
            text: "Setting",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingPage()),
            ),
          ),

          MyDrawerTile(
            text: "Log out",
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomePage()),
            ),
            textColor: Colors.red,
          ),

          const SizedBox(height: 20), // ระยะห่างด้านล่าง
        ],
      ),
    );
  }
}
