import 'package:flutter/material.dart';

class SelectAddressBar extends StatelessWidget {
  const SelectAddressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      pinned: true,
      floating: false,
      elevation: 2,
      title: Align(
        alignment: Alignment.centerLeft, //
        child: const Text(
          "เลือกที่อยู่",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
    );
  }
}
