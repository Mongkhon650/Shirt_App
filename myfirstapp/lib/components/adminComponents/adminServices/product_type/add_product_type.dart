import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'package:myfirstapp/utils/config.dart';

class AddProductPage extends StatefulWidget {
  final Function(String name, String imagePath) onAddCategory;

  const AddProductPage({required this.onAddCategory});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final file = File(pickedImage.path);
      if (file.existsSync() && file.lengthSync() > 0) {
        setState(() {
          _selectedImage = file;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไฟล์รูปภาพไม่ถูกต้อง')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่ได้เลือกรูปภาพ')),
      );
    }
  }

  Future<void> _addTypeToDatabase() async {
    if (_nameController.text.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }

    final uri = Uri.parse('${AppConfig.baseUrl}/api/add-product-type');
    final request = http.MultipartRequest('POST', uri);

    request.fields['name'] = _nameController.text;
    request.fields['createdBy'] = '1';

    final imageFile = _selectedImage!;
    final multipartFile = http.MultipartFile.fromBytes(
      'image',
      await imageFile.readAsBytes(),
      filename: p.basename(imageFile.path),
      contentType: MediaType('image', 'jpeg'),
    );
    request.files.add(multipartFile);

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เพิ่มประเภทสินค้าเรียบร้อยแล้ว')),
        );
        widget.onAddCategory(_nameController.text, _selectedImage!.path);
        Navigator.pop(context);
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Response Body: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เกิดข้อผิดพลาดในการเพิ่มประเภทสินค้า')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มประเภทสินค้า')),
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
                    : const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addTypeToDatabase,
              child: const Text('เพิ่มประเภท'),
            ),
          ],
        ),
      ),
    );
  }
}
