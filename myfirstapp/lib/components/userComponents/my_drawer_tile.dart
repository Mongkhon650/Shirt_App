import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color? textColor; // เพิ่ม textColor parameter

  const MyDrawerTile({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor, // รับค่า textColor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 100),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.grey.shade600,// ใช้สีที่ระบุหรือสีเทาเป็นค่าเริ่มต้น
            fontSize: 20, 
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
