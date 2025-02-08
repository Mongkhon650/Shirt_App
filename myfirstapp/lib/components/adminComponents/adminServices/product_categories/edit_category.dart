import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myfirstapp/utils/config.dart';

class EditCategoryPage extends StatefulWidget {
  final int categoryId;
  final String currentName;
  final Function() onUpdate;

  const EditCategoryPage({
    Key? key,
    required this.categoryId,
    required this.currentName,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EditCategoryPageState createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
  }

  Future<void> _updateCategory() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกชื่อหมวดหมู่')),
      );
      return;
    }

    try {
      // Prepare request body
      final requestBody = {
        'name': _nameController.text.trim(),
        'updatedBy': '1', // ส่งค่า updated_by
      };

      print('Request Body: $requestBody'); // Debug เพื่อตรวจสอบข้อมูล

      // ส่งคำขอไปยังเซิร์ฟเวอร์
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/update-category/${widget.categoryId}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('แก้ไขหมวดหมู่เรียบร้อยแล้ว')),
        );
        widget.onUpdate();
        Navigator.pop(context);
      } else {
        print('Response Body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('แก้ไขหมวดหมู่')),
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
              onPressed: _updateCategory,
              child: const Text('ยืนยันการแก้ไข'),
            ),
          ],
        ),
      ),
    );
  }
}
