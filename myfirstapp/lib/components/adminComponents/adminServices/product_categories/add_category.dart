import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myfirstapp/utils/config.dart';

class AddCategoryPage extends StatefulWidget {
  final Function() onAddCategory;

  const AddCategoryPage({Key? key, required this.onAddCategory}) : super(key: key);

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _addCategoryToDatabase() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกชื่อหมวดหมู่')),
      );
      return;
    }

    try {
      final requestBody = {
        'name': _nameController.text.trim(),
        'createdBy': '1',
      };

      print('Request Body (Flutter): $requestBody'); // Debug ข้อมูลที่จะส่งไป

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/add-category'),
        headers: {'Content-Type': 'application/json'}, // เพิ่ม Content-Type
        body: jsonEncode(requestBody), // แปลงข้อมูลเป็น JSON String
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เพิ่มหมวดหมู่เรียบร้อยแล้ว')),
        );
        widget.onAddCategory();
        Navigator.pop(context);
      } else {
        print('Response Body (Flutter): ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error (Flutter): $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มหมวดหมู่')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อหมวดหมู่',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addCategoryToDatabase,
              child: const Text('เพิ่มหมวดหมู่'),
            ),
          ],
        ),
      ),
    );
  }
}
