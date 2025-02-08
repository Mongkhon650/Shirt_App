import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:myfirstapp/utils/config.dart';

class EditProductPage extends StatefulWidget {
  final int productId;
  final String currentName;
  final double currentPrice;
  final String currentDescription;
  final String? currentImage;
  final bool usePromotion; // โปรโมชันใช้อยู่หรือไม่
  final double? discountRate; // ส่วนลด (ถ้ามี)
  final DateTime? startDate; // วันที่เริ่มต้นโปรโมชัน
  final DateTime? endDate; // วันที่สิ้นสุดโปรโมชัน
  final int currentStock; // จำนวนสินค้าในสต็อก
  final String currentProductType; // ประเภทสินค้า
  final String currentCategory; // หมวดหมู่สินค้า
  final Function() onUpdate;

  const EditProductPage({
    Key? key,
    required this.productId,
    required this.currentName,
    required this.currentPrice,
    required this.currentDescription,
    this.currentImage,
    required this.usePromotion,
    this.discountRate,
    this.startDate,
    this.endDate,
    required this.currentStock,
    required this.currentProductType,
    required this.currentCategory,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  File? _selectedImage;

  List<dynamic> _productTypes = [];
  List<dynamic> _categories = [];
  String? _selectedProductType;
  String? _selectedCategory;

  bool _usePromotion = false;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _priceController.text = widget.currentPrice.toString();
    _descriptionController.text = widget.currentDescription;
    _stockController.text = widget.currentStock.toString();
    _selectedProductType = widget.currentProductType;
    _selectedCategory = widget.currentCategory;

    _usePromotion = widget.usePromotion;
    if (_usePromotion) {
      _discountController.text = widget.discountRate?.toString() ?? '';
      _startDate = widget.startDate;
      _endDate = widget.endDate;
    }

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
          const SnackBar(content: Text('ไม่สามารถดึงข้อมูลประเภทและหมวดหมู่ได้')),
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
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProduct() async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}/api/update-product/${widget.productId}');
      final request = http.MultipartRequest('POST', uri);

      request.fields['name'] = _nameController.text.trim();
      request.fields['price'] = _priceController.text.trim();
      request.fields['description'] = _descriptionController.text.trim();
      request.fields['stock'] = _stockController.text.trim();
      request.fields['product_type_id'] = _selectedProductType!;
      request.fields['category_id'] = _selectedCategory!;
      request.fields['updatedBy'] = '1';

      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', _selectedImage!.path),
        );
      }

      request.fields['usePromotion'] = _usePromotion.toString();
      if (_usePromotion) {
        request.fields['discount_rate'] = _discountController.text.trim();
        request.fields['start_date'] = _startDate.toString();
        request.fields['end_date'] = _endDate.toString();
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('แก้ไขสินค้าสำเร็จ')),
        );
        widget.onUpdate();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('แก้ไขสินค้า')),
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
                decoration: const InputDecoration(labelText: 'ราคา'),
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
                      : widget.currentImage != null
                      ? Image.network(widget.currentImage!, fit: BoxFit.cover)
                      : const Center(child: Icon(Icons.image, size: 50)),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('เปิดใช้โปรโมชัน'),
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
                          initialDate: _startDate ?? DateTime.now(),
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
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now(),
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
                onPressed: _updateProduct,
                child: const Text('อัปเดตสินค้า'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
