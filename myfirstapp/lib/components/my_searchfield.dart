import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myfirstapp/utils/config.dart';

class MySearchfield extends StatefulWidget {
  final Function(List<dynamic>) onSearchResults;

  const MySearchfield({Key? key, required this.onSearchResults}) : super(key: key);

  @override
  State<MySearchfield> createState() => _MySearchfieldState();
}

class _MySearchfieldState extends State<MySearchfield> {
  TextEditingController searchController = TextEditingController();

  // ฟังก์ชันเรียก API
  Future<void> _fetchSearchResults(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/search-products?query=$query'),
      );

      if (response.statusCode == 200) {
        final results = json.decode(response.body) as List<dynamic>;
        widget.onSearchResults(results); // ส่งข้อมูลกลับไปยัง HomePage
      } else {
        throw Exception('ไม่สามารถค้นหาได้');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          _fetchSearchResults(value); // เรียก API เมื่อมีการพิมพ์
        } else {
          widget.onSearchResults([]); // ล้างผลลัพธ์เมื่อคำค้นหาว่าง
        }
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: "ค้นหาสินค้า...",
        border: OutlineInputBorder(),
      ),
    );
  }
}
