import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myfirstapp/components/userComponents/userServices/cate_dynamic_product.dart';
import 'package:myfirstapp/utils/config.dart';

class MyCategories extends StatefulWidget {
  const MyCategories({Key? key}) : super(key: key);

  @override
  _MyCategoriesState createState() => _MyCategoriesState();
}

class _MyCategoriesState extends State<MyCategories> {
  List<dynamic> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // ดึงข้อมูล Categories จาก API
  Future<void> _fetchCategories() async {
    try {
      final response =
      await http.get(Uri.parse('${AppConfig.baseUrl}/api/get-product-types')); // URL ของ API
      if (response.statusCode == 200) {
        setState(() {
          _categories = json.decode(response.body);
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
      color: Colors.grey.shade100,
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaceholderPage(categories: _categories), // ส่ง Categories ไป
                    ),
                  );
                },
                child: Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),

          // Categories List
          SizedBox(
            height: 100,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _categories.isEmpty
                ? Center(
              child: Text(
                'No categories available.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            )
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CateDynamicProductPage(
                          productTypeId: category['product_type_id'], // ส่ง product_type_id
                          categoryName: category['name'], // ส่งชื่อประเภท
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: category['image'] != null
                          ? DecorationImage(
                        image: NetworkImage(category['image']),
                        fit: BoxFit.cover,
                      )
                          : null,
                      color: Colors.grey.shade300,
                    ),
                    child: Center(
                      child: Text(
                        category['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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
  }
}

// PlaceholderPage สำหรับ View All
class PlaceholderPage extends StatelessWidget {
  final List<dynamic> categories;

  const PlaceholderPage({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Categories"),
      ),
      body: categories.isEmpty
          ? Center(
        child: Text(
          'No categories available.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // จำนวนคอลัมน์ใน Grid
          crossAxisSpacing: 4.0, // ปรับให้ชิดกันมากขึ้น
          mainAxisSpacing: 4.0, // ปรับให้ชิดกันมากขึ้น
          childAspectRatio: 1.2, // ปรับอัตราส่วนของ Card
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              // ไปที่หน้า CateDynamicProductPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CateDynamicProductPage(
                    productTypeId: category['product_type_id'], // ส่ง product_type_id
                    categoryName: category['name'], // ส่งชื่อหมวดหมู่
                  ),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: category['image'] != null
                        ? DecorationImage(
                      image: NetworkImage(category['image']),
                      fit: BoxFit.cover,
                    )
                        : null,
                    color: Colors.grey.shade300,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    //color: Colors.black.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Text(
                      category['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
