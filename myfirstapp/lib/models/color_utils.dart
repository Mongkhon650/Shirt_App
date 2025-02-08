import 'package:flutter/material.dart';

// ฟังก์ชันช่วยในการแปลงชื่อสีให้เป็นค่าสีจริง
Color getColorFromName(String colorName) {
  switch (colorName) {
    case "lightBlue":
      return Colors.lightBlue;
    case "white":
      return Colors.white;
    case "orange":
      return Colors.orange;
    case "green":
      return Colors.green;
    case "blue":
      return Colors.blue;
    default:
      return Colors.grey; // สีเริ่มต้นในกรณีที่ไม่มีสีที่ตรงกัน
  }
}