import 'package:flutter/material.dart';

class CategoryModel with ChangeNotifier {
  // รายการประเภทสินค้า
  final List<Map<String, dynamic>> _categories = [];

  // ให้หน้าอื่นเรียกใช้งานรายการประเภทสินค้าได้
  List<Map<String, dynamic>> get categories => List.unmodifiable(_categories);

  // ฟังก์ชันเพิ่มประเภทสินค้า
  void addCategory(String name, String imagePath) {
    _categories.add({'name': name, 'imagePath': imagePath});
    notifyListeners(); // แจ้งให้ Widget ที่เชื่อมต่อ Model อัปเดต
  }

  // ฟังก์ชันลบประเภทสินค้า
  void deleteCategory(int index) {
    _categories.removeAt(index);
    notifyListeners();
  }

  // ฟังก์ชันแก้ไขประเภทสินค้า
  void editCategory(int index, String newName) {
    _categories[index]['name'] = newName;
    notifyListeners();
  }
}
