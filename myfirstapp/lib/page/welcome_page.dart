import 'package:flutter/material.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/page/login_page.dart';
import 'package:myfirstapp/page/register_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void select_login() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          onTap: () {
            // กำหนดการทำงานเมื่อกด Sign Up ในหน้า Login
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterPage(
                  onTap: () {
                    // กำหนดการทำงานเมื่อกด Sign In ในหน้า Register
                    Navigator.pop(context); // กลับไปหน้า Login
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void select_register() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(
          onTap: () {
            // กำหนดการทำงานเมื่อกด Sign In ในหน้า Register
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(
                  onTap: () {
                    // กำหนดการทำงานเมื่อกด Sign Up ในหน้า Login
                    Navigator.pop(context); // กลับไปหน้า Register
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 45),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // text
              Text(
                "Welcome to BosShop",
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
              Text(
                "Explore Thailand",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 80),

              // images
              Image.asset(
                "assets/images/login-icon.png",
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 160),

              // login button
              MyButton(onTap: select_login, text: "Login"),
              const SizedBox(height: 15),

              // signup button
              GestureDetector(
                onTap: select_register,
                child: Text(
                  "Signup",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
