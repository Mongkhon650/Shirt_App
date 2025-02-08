import 'package:http/http.dart' as http;
import 'package:myfirstapp/utils/config.dart';

class ProductTypeServiceDel {
  static Future<void> deleteProductType(int id) async {
    try {
      final response = await http.delete(Uri.parse('${AppConfig.baseUrl}/api/delete-product-type/$id'));
      if (response.statusCode != 200) {
        throw Exception('เกิดข้อผิดพลาดในการลบประเภทสินค้า');
      }
    } catch (e) {
      print('Error deleting product type: $e');
      throw Exception('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้');
    }
  }
}
