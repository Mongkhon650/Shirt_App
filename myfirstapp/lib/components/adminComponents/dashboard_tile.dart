import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myfirstapp/utils/config.dart';

class DashboardTile extends StatefulWidget {
  @override
  _DashboardTileState createState() => _DashboardTileState();
}

class _DashboardTileState extends State<DashboardTile> {
  bool _isLoading = true;
  Map<String, dynamic> _dashboardData = {
    "productTypes": 0,
    "products": 0,
    "categories": 0,
    "orders": 0,
    "users": 0,
    "revenue": 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      // สมมติ URL API
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/dashboard'));
      if (response.statusCode == 200) {
        setState(() {
          _dashboardData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          alignment: WrapAlignment.start,
          children: [
            MenuBox(
              count: _dashboardData["productTypes"],
              label: "ประเภทสินค้า",
              onTap: () => print("ประเภทสินค้า"),
            ),
            MenuBox(
              count: _dashboardData["products"],
              label: "รายการสินค้า",
              onTap: () => print("รายการสินค้า"),
            ),
            MenuBox(
              count: _dashboardData["categories"],
              label: "หมวดหมู่",
              onTap: () => print("หมวดหมู่"),
            ),
            MenuBox(
              count: _dashboardData["orders"],
              label: "สินค้าที่ถูกสั่งซื้อ",
              onTap: () => print("สินค้าที่ถูกสั่งซื้อ"),
            ),
            MenuBox(
              count: _dashboardData["users"],
              label: "จำนวนผู้ใช้งาน",
              onTap: () => print("จำนวนผู้ใช้งาน"),
            ),
            MenuBox(
              count: _dashboardData["revenue"],
              label: "รายได้",
              onTap: () => print("รายได้"),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuBox extends StatelessWidget {
  final int count;
  final String label;
  final VoidCallback onTap;

  const MenuBox({
    required this.count,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        constraints: const BoxConstraints(maxWidth: 350),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 4.0,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
