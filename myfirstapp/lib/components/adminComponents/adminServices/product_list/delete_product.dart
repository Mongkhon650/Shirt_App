import 'package:http/http.dart' as http;
import 'package:myfirstapp/utils/config.dart';

class ProductServiceDelete {
  static Future<void> deleteProduct(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppConfig.baseUrl}/api/delete-product/$productId'),
      );

      if (response.statusCode != 200) {
        throw Exception('เกิดข้อผิดพลาดในการลบสินค้า');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้');
    }
  }
}
