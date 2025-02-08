import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfirstapp/utils/config.dart';

class AuthService {
  final String baseUrl = "${AppConfig.baseUrl}/api/auth"; // ใช้ URL เดียวกัน

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("Raw Response Status Code: ${response.statusCode}");
      print("Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Decoded Data: $data");

        return {
          "success": true,
          "token": data["token"],
          "name": data["name"],
          "isAdmin": data["isAdmin"],
          "user_id": data["user_id"], // ใช้ key "user_id" จาก API response
        };
      } else {
        final data = jsonDecode(response.body);
        return {"success": false, "message": data["message"]};
      }
    } catch (e) {
      print("Exception during login: $e");
      return {"success": false, "message": e.toString()};
    }
  }

  // ฟังก์ชันลงทะเบียน (ใช้ได้เฉพาะ User)
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      // URL สำหรับลงทะเบียนผู้ใช้ (Admin ไม่สามารถลงทะเบียนผ่านระบบ)
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      print("Raw Response Body: ${response.body}");

      // ตรวจสอบสถานะการตอบกลับ
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Decoded Data: $data");

        return {"success": true, "message": data["message"]};
      } else {
        // กรณีข้อมูลไม่ถูกต้อง
        final data = jsonDecode(response.body);
        print("Error Response: $data");
        return {"success": false, "message": data["message"]};
      }
    } catch (e) {
      // กรณีเกิดข้อผิดพลาดอื่น ๆ
      return {"success": false, "message": e.toString()};
    }
  }
}
