import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dynamic_product.dart';
import 'package:myfirstapp/utils/config.dart';

class CateDynamicProductPage extends StatefulWidget {
  final int productTypeId; // รับ productTypeId เพื่อดึงสินค้าตามประเภท
  final String categoryName; // ชื่อหมวดหมู่ที่จะแสดงใน AppBar

  const CateDynamicProductPage({
    Key? key,
    required this.productTypeId,
    required this.categoryName,
  }) : super(key: key);

  @override
  _CateDynamicProductPageState createState() => _CateDynamicProductPageState();
}

class _CateDynamicProductPageState extends State<CateDynamicProductPage> {
  List<dynamic> _products = []; // เก็บข้อมูลสินค้า
  bool _isLoading = true; // สถานะการโหลด

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  // ดึงข้อมูลสินค้าจาก API ตามประเภท
  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/get-products-by-type/${widget.productTypeId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _products = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName), // แสดงชื่อหมวดหมู่
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // แสดงสถานะโหลด
          : _products.isEmpty
          ? const Center(
        child: Text('No products available.'), // ไม่มีสินค้า
      )
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // จำนวนคอลัมน์
          crossAxisSpacing: 8, // ระยะห่างระหว่างคอลัมน์
          mainAxisSpacing: 8, // ระยะห่างระหว่างแถว
          childAspectRatio: 0.97, // อัตราส่วนของการ์ดสินค้า
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return GestureDetector(
            onTap: () {
              // เมื่อคลิกสินค้า ให้ไปยังหน้ารายละเอียดสินค้า
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DynamicProductPage(
                    productId: product['product_id'], // ส่ง product_id
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // รูปสินค้า
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          product['image'] ??
                              'https://via.placeholder.com/150',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ราคาสินค้า
                        Text(
                          '฿${product['price'] ?? '0.00'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        // ชื่อสินค้า
                        Text(
                          product['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
