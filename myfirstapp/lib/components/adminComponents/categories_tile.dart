import 'package:flutter/material.dart';
import 'adminServices/product_categories/get_category.dart';
import 'adminServices/product_categories/delete_category.dart';
import 'adminServices/product_categories/add_category.dart';
import 'adminServices/product_categories/edit_category.dart';

class CategoriesTile extends StatefulWidget {
  @override
  _CategoriesTileState createState() => _CategoriesTileState();
}

class _CategoriesTileState extends State<CategoriesTile> {
  List<dynamic> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // ดึงข้อมูลหมวดหมู่
  Future<void> _fetchCategories() async {
    try {
      final categories = await CategoryServiceGet.fetchCategories(); // เรียกจาก get_category.dart
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // ลบหมวดหมู่
  Future<void> _deleteCategory(int id) async {
    try {
      await CategoryServiceDelete.deleteCategory(id); // เรียกจาก delete_category.dart
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบหมวดหมู่เรียบร้อยแล้ว')),
      );
      await _fetchCategories(); // รีเฟรชข้อมูลหลังลบ
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: _categories.isEmpty
                ? Center(child: Text('ยังไม่มีหมวดหมู่'))
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category['name'],
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
                                  builder: (context) => EditCategoryPage(
                                    categoryId: category['category_id'],
                                    currentName: category['name'],
                                    onUpdate: _fetchCategories,
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
                                  content: Text('คุณต้องการลบหมวดหมู่นี้หรือไม่?'),
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
                                await _deleteCategory(category['category_id']);
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
                    builder: (context) => AddCategoryPage(onAddCategory: _fetchCategories),
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
                    'เพิ่มหมวดหมู่',
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
