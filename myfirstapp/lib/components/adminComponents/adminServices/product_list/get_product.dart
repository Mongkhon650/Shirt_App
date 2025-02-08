import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myfirstapp/utils/config.dart';

class ProductServiceGet {
  static Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/get-products'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('เกิดข้อผิดพลาดในการดึงข้อมูลสินค้า');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้');
    }
  }
}
