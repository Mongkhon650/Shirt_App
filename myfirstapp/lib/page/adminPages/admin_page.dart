import 'package:flutter/material.dart';
import 'package:myfirstapp/components/adminComponents/categories_tile.dart';
import 'package:myfirstapp/components/adminComponents/dashboard_tile.dart';
import 'package:myfirstapp/components/adminComponents/ordered_product_tile.dart';
import 'package:myfirstapp/components/adminComponents/product_list_tile.dart';
import 'package:myfirstapp/components/adminComponents/product_type_tile.dart';
import 'package:myfirstapp/components/adminComponents/user_detile_tile.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  int _selectedIndex = 0;

  final List<String> _menuItems = [
    "Dashboard",
    "ประเภทสินค้า",
    "รายการสินค้า",
    "หมวดหมู่",
    "สินค้าที่ถูกสั่งซื้อ",
    "จำนวนผู้ใช้งาน",
  ];

  final List<Widget> _pages = [
    DashboardTile(),
    ProductTypeTile(),
    ProductListTile(),
    CategoriesTile(),
    OrderedProductTile(),
    UserDetailTile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_menuItems.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Text(
                        _menuItems[index],
                        style: TextStyle(
                          color: _selectedIndex == index ? Colors.blue : Colors.black,
                          fontWeight: _selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}









