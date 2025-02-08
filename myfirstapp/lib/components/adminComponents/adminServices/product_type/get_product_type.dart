import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myfirstapp/utils/config.dart';

class ProductTypeServiceGet {
  static Future<List<dynamic>> fetchProductTypes() async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}/api/get-product-types'));
      if (response.statusCode == 200) {
        return json.decode(response.body); // แปลงข้อมูล JSON เป็น List
      } else {
        throw Exception('เกิดข้อผิดพลาดในการดึงข้อมูลประเภทสินค้า');
      }
    } catch (e) {
      print('Error fetching product types: $e');
      throw Exception('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้');
    }
  }
}
