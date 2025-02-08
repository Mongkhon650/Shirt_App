import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dynamic_product.dart';
import 'package:myfirstapp/utils/config.dart';

class DynamicListCategories extends StatefulWidget {
  const DynamicListCategories({Key? key}) : super(key: key);

  @override
  _DynamicListCategoriesState createState() => _DynamicListCategoriesState();
}

class _DynamicListCategoriesState extends State<DynamicListCategories> {
  List<dynamic> _categories = [];
  Map<int, List<dynamic>> _productsByCategory = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategoriesAndProducts();
  }

  // ดึงข้อมูลหมวดหมู่และสินค้า
  Future<void> _fetchCategoriesAndProducts() async {
    try {
      // ดึงหมวดหมู่
      final categoriesResponse = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/get-categories'),
      );

      if (categoriesResponse.statusCode == 200) {
        final categories = json.decode(categoriesResponse.body);

        // ดึงสินค้าแต่ละหมวดหมู่
        for (var category in categories) {
          final categoryId = category['category_id'];
          final productsResponse = await http.get(
            Uri.parse('${AppConfig.baseUrl}/api/get-products/$categoryId'), // ใช้ API ใหม่
          );

          if (productsResponse.statusCode == 200) {
            final products = json.decode(productsResponse.body);
            _productsByCategory[categoryId] = products;
          } else {
            _productsByCategory[categoryId] = [];
          }
        }

        setState(() {
          _categories = categories;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load categories');
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
    return Container(
      color: Colors.grey.shade100, // ตั้งพื้นหลังให้เหมือน Homepage
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // แสดงหมวดหมู่และรายการสินค้า
            ..._categories.map((category) {
              final categoryId = category['category_id'];
              final categoryName = category['name'];
              final products = _productsByCategory[categoryId] ?? [];

              return Container(
                color: Colors.grey.shade100, // ตั้งพื้นหลังของแต่ละหมวดหมู่
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Header (ชื่อหมวดหมู่)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            categoryName,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryProductsPage(
                                        categoryName: categoryName,
                                        products: products,
                                      ),
                                ),
                              );
                            },
                            child: Text(
                                'View all',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // แสดงสินค้าในหมวดหมู่
                    Container(
                      color: Colors.grey.shade100, // พื้นหลังรายการสินค้า
                      height: 200,
                      child: products.isEmpty
                          ? const Center(
                        child: Text(
                          'No products available.',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      )
                          : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                // นำไปยังหน้ารายละเอียดสินค้า
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DynamicProductPage(
                                      productId: product['product_id'], // ส่ง productId ไปยัง DynamicProductPage
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 140,
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
                                      height: 124,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            product['image'] ?? 'https://via.placeholder.com/150',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // ราคาและชื่อสินค้า
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // ราคา (อยู่ด้านบน)
                                          Text(
                                            '\$${product['price'] ?? '0.00'}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey, // เปลี่ยนสีเป็นเทา
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          // ชื่อสินค้า (อยู่ด้านล่าง)
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
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

}

// หน้า View All สำหรับสินค้าในหมวดหมู่
class CategoryProductsPage extends StatelessWidget {
  final String categoryName;
  final List<dynamic> products;

  const CategoryProductsPage({
    Key? key,
    required this.categoryName,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: products.isEmpty
          ? const Center(
        child: Text('No products available.'),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // แสดงสินค้า 2 คอลัมน์
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              // ไปหน้า DynamicProductPage พร้อมส่ง productId
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DynamicProductPage(
                    productId: product['product_id'], // ส่ง productId
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
                  // รูปภาพสินค้า
                  Container(
                    height: 135,
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
                  // ชื่อสินค้าและราคา
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${product['price'] ?? '0.00'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
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