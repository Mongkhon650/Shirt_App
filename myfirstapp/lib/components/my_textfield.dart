import 'package:flutter/material.dart';

// Custom TextField widget ที่มีไอคอน suffix option สำหรับแสดงหรือซ่อนข้อความ
class MyTextfield extends StatefulWidget {
  final TextEditingController controller; // Controller สำหรับการจัดการ text input
  final String labelText; // Label สำหรับ text field
  final bool obscureText; // กำหนดว่าข้อความควรจะซ่อนหรือแสดง (เช่น สำหรับรหัสผ่าน)
  final bool showSuffixIcon; // กำหนดว่าจะมีไอคอน suffix สำหรับการสลับแสดง/ซ่อนข้อความหรือไม่

  const MyTextfield({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    this.showSuffixIcon = true, // ค่าเริ่มต้นเป็น true เพื่อแสดงไอคอนสลับการแสดงข้อความ
  });

  @override
  _MyTextfieldState createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  // ตัวแปรควบคุมว่า ข้อความจะถูกซ่อนหรือแสดง
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText; // กำหนดค่าเริ่มต้นของ _obscureText จาก input ที่ส่งมา
  }

  // ฟังก์ชันสลับการแสดงข้อความเมื่อกดไอคอน
  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText, // กำหนดการแสดงข้อความตาม _obscureText
        decoration: InputDecoration(
          labelText: widget.labelText, // แสดง label ของ text field
          labelStyle: const TextStyle(color: Colors.black38), // สไตล์ของ label
          floatingLabelStyle: const TextStyle(color: Colors.blue), // สไตล์ของ floating label เมื่อมี focus
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0), // สีของ border เมื่อ focused
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black38, width: 1.0), // สีของ border เมื่อไม่มี focus
          ),

          // ไอคอน suffix สำหรับการสลับการแสดงข้อความ
          suffixIcon: widget.showSuffixIcon
              ? IconButton(
                  icon: Icon(
                    // เลือกไอคอนตามค่า _obscureText
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black38,
                  ),
                  onPressed: _toggleVisibility, // เรียกฟังก์ชันสลับการแสดงเมื่อกดไอคอน
                )
              : null, // หาก showSuffixIcon เป็น false จะไม่มีไอคอนปรากฏ

          /* อธิบาย: 
          1.กำหนด IconButton เป็น suffixIcon: ตรวจสอบค่า showSuffixIcon ที่ได้รับมาจาก MyTextfield 
          ถ้าค่าเป็น true ก็จะทำตามเงื่อนไขที่ระบุในเครื่องหมาย ? (ถัดจากเครื่องหมาย :) ถ้าค่าเป็น false จะกำหนดค่า suffixIcon เป็น null.

          2.กำหนด IconButton เป็น suffixIcon:ถ้า showSuffixIcon เป็น true จะสร้าง IconButton ที่เป็น suffixIcon.

          3.การเลือกไอคอน (Icon):ไอคอนจะแสดง Icons.visibility_off ถ้าค่า _obscureText เป็น true ซึ่งหมายความว่ารหัสผ่านถูกซ่อนไว้.
          ไอคอนจะแสดง Icons.visibility ถ้าค่า _obscureText เป็น false ซึ่งหมายความว่ารหัสผ่านถูกเปิดเผย.
          
          4.การกำหนด onPressed ของ IconButton:เมื่อกดที่ IconButton ฟังก์ชัน _toggleVisibility 
          จะถูกเรียกใช้เพื่อสลับค่าของ _obscureText ระหว่าง true และ false.

          5.กรณี showSuffixIcon เป็น false:ถ้า showSuffixIcon เป็น false ค่า suffixIcon จะถูกตั้งเป็น null ซึ่งหมายความว่า TextField นี้จะไม่มีไอคอนด้านขวา.
          */
        ),
      ),
    );
  }
}
