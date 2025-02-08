import 'package:flutter/material.dart';
import 'adminServices/product_list/add_product.dart';
import 'adminServices/product_list/edit_product.dart';
import 'adminServices/product_list/get_product.dart'; // สำหรับดึงข้อมูลสินค้า
import 'adminServices/product_list/delete_product.dart'; // สำหรับลบสินค้า

class ProductListTile extends StatefulWidget {
  @override
  _ProductListTileState createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  // ดึงข้อมูลสินค้า
  Future<void> _fetchProducts() async {
    try {
      final products = await ProductServiceGet.fetchProducts(); // ดึงข้อมูลจาก API
      setState(() {
        _products = products;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  // ลบสินค้า
  Future<void> _deleteProduct(int id) async {
    try {
      await ProductServiceDelete.deleteProduct(id); // ลบสินค้าผ่าน API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อยแล้ว')),
      );
      await _fetchProducts(); // อัปเดตรายการสินค้า
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  // ฟังก์ชันเพิ่มสินค้า
  void _onAddProduct() async {
    await _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _products.isEmpty
                ? Center(child: Text('ยังไม่มีสินค้า'))
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];

                // ตรวจสอบโปรโมชันที่เกี่ยวข้องกับสินค้า
                final bool usePromotion = product['promotion'] != null;
                final double? discountRate =
                usePromotion ? product['promotion']['discount_rate'] : null;
                final DateTime? startDate = usePromotion
                    ? DateTime.tryParse(product['promotion']['start_date'])
                    : null;
                final DateTime? endDate = usePromotion
                    ? DateTime.tryParse(product['promotion']['end_date'])
                    : null;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      product['image'] != null
                          ? Image.network(
                        product['image'], // URL ของรูปสินค้า
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image,
                              size: 50, color: Colors.grey);
                        },
                      )
                          : Container(
                        height: 80,
                        color: Colors.blue.shade100,
                        child: Center(
                          child: Text(
                            'รูป',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        product['name'] ?? 'ชื่อสินค้า',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        product['product_type_name'] ?? 'ประเภทสินค้า',
                        style: TextStyle(fontSize: 12),
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
                                  builder: (context) => EditProductPage(
                                    productId: product['product_id'],
                                    currentName: product['name'] ?? '',
                                    currentDescription:
                                    product['description'] ?? '',
                                    currentPrice: double.tryParse(
                                        product['price'].toString()) ??
                                        0.0,
                                    currentImage: product['image'],
                                    usePromotion: usePromotion,
                                    discountRate: discountRate,
                                    startDate: startDate,
                                    endDate: endDate,
                                    currentStock: product['stock'] ?? 0,
                                    currentProductType:
                                    product['product_type_id']
                                        .toString(),
                                    currentCategory:
                                    product['category_id'].toString(),
                                    onUpdate: _fetchProducts,
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
                                  content: Text(
                                      'คุณต้องการลบสินค้านี้หรือไม่?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text('ยกเลิก'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text('ยืนยัน'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await _deleteProduct(
                                    product['product_id']);
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
                    builder: (context) =>
                        AddProductPage(onAddProduct: _onAddProduct),
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
                    'เพิ่มรายการสินค้า',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
