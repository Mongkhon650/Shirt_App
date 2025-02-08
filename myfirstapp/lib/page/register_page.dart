import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/components/my_textfield.dart';
import 'package:myfirstapp/services/auth_service.dart';
import 'package:myfirstapp/page/login_page.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  final AuthService authService = AuthService();

  void register() async {
    final response = await authService.register(
      userNameController.text,
      emailController.text,
      passwordController.text,
    );

    print("Response from API: $response"); // ตรวจสอบค่า Response

    if (response["success"] == true) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: Text(response["message"]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"] ?? "An error occurred")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              "Sign Up",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Name textfield
          MyTextfield(
            controller: userNameController,
            labelText: "Name",
            obscureText: false,
            showSuffixIcon: false,
          ),

          const SizedBox(height: 10),

          // Email textfield
          MyTextfield(
            controller: emailController,
            labelText: "Email",
            obscureText: false,
            showSuffixIcon: false,
          ),

          const SizedBox(height: 10),

          // Password textfield
          MyTextfield(
            controller: passwordController,
            labelText: "Password",
            obscureText: true,
            showSuffixIcon: true,
          ),

          const SizedBox(height: 35),

          MyButton(
            onTap: register,
            text: "Sign Up",
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account ?",
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
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                child: const Text(
                  "Sign in",
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
