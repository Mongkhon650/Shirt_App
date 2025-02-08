import 'package:flutter/material.dart';

import '../../components/my_textfield.dart';

class EditSettingPage extends StatefulWidget {
  const EditSettingPage({super.key});

  @override
  State<EditSettingPage> createState() => _EditSettingPageState();
}

class _EditSettingPageState extends State<EditSettingPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void onConfirm() {
    // Validate inputs and handle saving new data
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    // Implement save logic here
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: const Text(
          'แก้ไขข้อมูลส่วนตัว',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              MyTextfield(
                controller: nameController,
                labelText: "ชื่อใหม่",
                obscureText: false,
                showSuffixIcon: false,
              ),

              const SizedBox(height: 10),


              MyTextfield(
                controller: emailController,
                labelText: "Email",
                obscureText: false,
                showSuffixIcon: false,
              ),

              MyTextfield(
                controller: newPasswordController,
                labelText: "รหัสผ่านใหม่",
                obscureText: false,
                showSuffixIcon: false,
              ),

              const SizedBox(height: 10),


              MyTextfield(
                controller: confirmPasswordController,
                labelText: "ยืนยันรหัสผ่าน",
                obscureText: true,
              ),

              const SizedBox(height: 36),

              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // ทำให้ปุ่มอยู่ตรงกลาง
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 12),
                    ),
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 36), // เพิ่มระยะห่างเล็กน้อยระหว่างปุ่ม
                  ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 12),
                    ),
                    child: const Text(
                      'ยืนยัน',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}