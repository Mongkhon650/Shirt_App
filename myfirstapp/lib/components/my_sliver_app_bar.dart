import 'package:flutter/material.dart';
import 'package:myfirstapp/page/userPages/cart_page.dart';

class MySliverAppBar extends StatelessWidget {


  const MySliverAppBar({super.key,});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.grey.shade100,
      // appbar เลื่อนตามจอ
      pinned: true,
      actions: [
        IconButton(onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => CartPage()),
          );
        }, 
        icon: const Icon(Icons.shopping_bag_outlined)
        ),
      ],
    );
  }
}