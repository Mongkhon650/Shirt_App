import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p; // ใช้สำหรับจัดการชื่อไฟล์
import 'package:myfirstapp/utils/config.dart';

class EditProductTypePage extends StatefulWidget {
  final int productTypeId;
  final String currentName;
  final String currentImage;
  final Function() onUpdate;

  const EditProductTypePage({
    required this.productTypeId,
    required this.currentName,
    required this.currentImage,
    required this.onUpdate,
  });

  @override
  _EditProductTypePageState createState() => _EditProductTypePageState();
}

class _EditProductTypePageState extends State<EditProductTypePage> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่ได้เลือกรูปภาพ')),
      );
    }
  }

  Future<void> _updateProductType() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }

    try {
      final uri = Uri.parse('${AppConfig.baseUrl}/api/update-product-type/${widget.productTypeId}');
      final request = http.MultipartRequest('POST', uri);

      request.fields['name'] = _nameController.text;

      if (_selectedImage != null) {
        final stream = http.ByteStream(_selectedImage!.openRead());
        final length = await _selectedImage!.length();
        final multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: p.basename(_selectedImage!.path),
        );
        request.files.add(multipartFile);
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('แก้ไขประเภทสินค้าเรียบร้อยแล้ว')),
        );
        widget.onUpdate();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เกิดข้อผิดพลาดในการแก้ไขประเภทสินค้า')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('แก้ไขประเภท')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อประเภท',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : Image.network(widget.currentImage, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateProductType,
              child: const Text('ยืนยันการแก้ไข'),
            ),
          ],
        ),
      ),
    );
  }
}
