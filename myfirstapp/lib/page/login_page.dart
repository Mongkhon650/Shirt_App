import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/components/my_textfield.dart';
import 'package:myfirstapp/page/userPages/home_page.dart';
import 'package:myfirstapp/services/auth_service.dart';
import 'package:myfirstapp/page/register_page.dart';
import 'package:myfirstapp/page/adminPages/admin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService authService = AuthService();
  bool isLoading = false; // เพิ่มตัวแปรสำหรับสถานะการโหลด

  void login() async {
    setState(() {
      isLoading = true; // เริ่มโหลด
    });

    try {
      final response = await authService.login(
        emailController.text,
        passwordController.text,
      );

      print("Response from API: $response");

      if (response["success"] == true) {
        // เก็บ user_id ไว้ใน SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', response["user_id"]); // เก็บ user_id

        if (response["isAdmin"] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(userName: response["name"]),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Login failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
      print("Error during login: $e");
    } finally {
      setState(() {
        isLoading = false; // หยุดโหลด
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon กลับไปหน้าเดิม
          Container(
            margin: const EdgeInsets.only(top: 30, left: 6),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // ช่องกรอก Email
          MyTextfield(
            controller: emailController,
            labelText: "Email",
            obscureText: false,
            showSuffixIcon: false,
          ),

          const SizedBox(height: 10),

          // ช่องกรอกรหัสผ่าน
          MyTextfield(
            controller: passwordController,
            labelText: "Password",
            obscureText: true,
          ),

          const SizedBox(height: 35),

          // ปุ่ม Login
          isLoading
              ? const Center(child: CircularProgressIndicator()) // แสดงโหลด
              : MyButton(
            onTap: login,
            text: "Login",
          ),

          const SizedBox(height: 10),

          // ข้อความไปยังหน้า Sign Up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: widget.onTap ??
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
