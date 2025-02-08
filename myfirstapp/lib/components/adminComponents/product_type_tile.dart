import 'package:flutter/material.dart';
import 'adminServices/product_type/add_product_type.dart';
import 'adminServices/product_type/edit_product_type.dart';
import 'adminServices/product_type/get_product_type.dart'; // นำเข้า get_product_type.dart
import 'adminServices/product_type/delete_product_type.dart'; // นำเข้า delete_product_type.dart

class ProductTypeTile extends StatefulWidget {
  @override
  _ProductTypeTileState createState() => _ProductTypeTileState();
}

class _ProductTypeTileState extends State<ProductTypeTile> {
  List<dynamic> _productTypes = [];

  @override
  void initState() {
    super.initState();
    _fetchProductTypes();
  }

  // ดึงข้อมูลประเภทสินค้า
  Future<void> _fetchProductTypes() async {
    try {
      final productTypes = await ProductTypeServiceGet.fetchProductTypes(); // ใช้บริการ fetchProductTypes
      setState(() {
        _productTypes = productTypes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // ลบประเภทสินค้า
  Future<void> _deleteProductType(int id) async {
    try {
      await ProductTypeServiceDel.deleteProductType(id); // ใช้บริการ deleteProductType
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบประเภทสินค้าเรียบร้อยแล้ว')),
      );
      await _fetchProductTypes(); // รีเฟรชข้อมูลหลังลบ
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _onAddType(String name, String imagePath) async {
    await _fetchProductTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _productTypes.isEmpty
                ? Center(child: Text('ยังไม่มีประเภทสินค้า'))
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _productTypes.length,
              itemBuilder: (context, index) {
                final productType = _productTypes[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      productType['image'] != null
                          ? Image.network(
                        productType['image'], // URL รูปภาพจากเซิร์ฟเวอร์
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Failed to load image: ${productType['image']}'); // Debug log
                          return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                        },
                      )
                          : Icon(Icons.image, size: 50, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        productType['name'],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProductTypePage(
                                    productTypeId: productType['product_type_id'],
                                    currentName: productType['name'],
                                    currentImage: productType['image'],
                                    onUpdate: _fetchProductTypes,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('ยืนยันการลบ'),
                                  content: Text('คุณต้องการลบประเภทสินค้านี้หรือไม่?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text('ยกเลิก'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: Text('ยืนยัน'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await _deleteProductType(productType['product_type_id']);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProductPage(onAddCategory: _onAddType),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'เพิ่มประเภท',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
