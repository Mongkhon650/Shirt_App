import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:myfirstapp/utils/config.dart';

class AddProductPage extends StatefulWidget {
  final Function() onAddProduct;

  const AddProductPage({Key? key, required this.onAddProduct}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  List<dynamic> _productTypes = [];
  List<dynamic> _categories = [];
  String? _selectedProductType;
  String? _selectedCategory;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Promotion fields
  bool _usePromotion = false; // Toggle for promotion
  final TextEditingController _discountController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchProductTypesAndCategories();
  }

  Future<void> _fetchProductTypesAndCategories() async {
    try {
      final productTypeResponse =
      await http.get(Uri.parse('${AppConfig.baseUrl}/api/get-product-types'));
      final categoryResponse =
      await http.get(Uri.parse('${AppConfig.baseUrl}/api/get-categories'));

      if (productTypeResponse.statusCode == 200 &&
          categoryResponse.statusCode == 200) {
        setState(() {
          _productTypes = json.decode(productTypeResponse.body);
          _categories = json.decode(categoryResponse.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถดึงข้อมูลได้')),
        );
      }
    } catch (e) {
      print('Error fetching product types or categories: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อ API')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _addProduct() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _selectedProductType == null ||
        _selectedCategory == null ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }

    try {
      final uri = Uri.parse('${AppConfig.baseUrl}/api/add-product');
      final request = http.MultipartRequest('POST', uri);

      // ส่งข้อมูลสินค้า
      request.fields['name'] = _nameController.text.trim();
      request.fields['price'] = _priceController.text.trim();
      request.fields['description'] = _descriptionController.text.trim();
      request.fields['stock'] = _stockController.text.trim();
      request.fields['product_type_id'] = _selectedProductType!;
      request.fields['category_id'] = _selectedCategory!;
      request.fields['createdBy'] = '1';

      // ส่งข้อมูลโปรโมชัน (ถ้าเปิดใช้)
      request.fields['usePromotion'] = _usePromotion.toString();
      if (_usePromotion) {
        request.fields['discount_rate'] = _discountController.text.trim();
        request.fields['start_date'] = _startDate.toString();
        request.fields['end_date'] = _endDate.toString();
      }

      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', _selectedImage!.path),
        );
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('เพิ่มสินค้าสำเร็จ')),
        );
        widget.onAddProduct();
        Navigator.pop(context);
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Error: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $responseBody')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้: $e')),
      );
    }
  }


  Future<void> _addPromotion(int productId) async {
    if (_discountController.text.isEmpty || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลโปรโมชันให้ครบถ้วน')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/add-promotion'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'product_id': productId,
          'discount_rate': double.parse(_discountController.text),
          'start_date': _startDate.toString(),
          'end_date': _endDate.toString(),
          'created_by': 1,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add promotion');
      }
    } catch (e) {
      print('Error adding promotion: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มสินค้า')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'ราคาสินค้า'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'รายละเอียดสินค้า'),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedProductType,
                items: _productTypes.map((type) {
                  return DropdownMenuItem(
                    value: type['product_type_id'].toString(),
                    child: Text(type['name']),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedProductType = value),
                decoration: const InputDecoration(labelText: 'ประเภทสินค้า'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category['category_id'].toString(),
                    child: Text(category['name']),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                decoration: const InputDecoration(labelText: 'หมวดหมู่สินค้า'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'จำนวนสินค้าในสต็อก'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : const Center(child: Icon(Icons.image, size: 50)),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('เปิดใช้ฟังก์ชันโปรโมชัน'),
                value: _usePromotion,
                onChanged: (value) => setState(() => _usePromotion = value!),
              ),
              if (_usePromotion)
                Column(
                  children: [
                    TextField(
                      controller: _discountController,
                      decoration: const InputDecoration(labelText: 'ส่วนลด (%)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() => _startDate = pickedDate);
                        }
                      },
                      child: Text(
                        _startDate == null
                            ? 'เลือกวันที่เริ่มต้น'
                            : 'เริ่มต้น: ${_startDate.toString().split(' ')[0]}',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() => _endDate = pickedDate);
                        }
                      },
                      child: Text(
                        _endDate == null
                            ? 'เลือกวันที่สิ้นสุด'
                            : 'สิ้นสุด: ${_endDate.toString().split(' ')[0]}',
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addProduct,
                child: const Text('เพิ่มสินค้า'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
