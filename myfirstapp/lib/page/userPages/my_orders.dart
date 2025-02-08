import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfirstapp/models/new_cart.dart';
import 'package:myfirstapp/components/userComponents/cart_tile.dart';
import 'package:myfirstapp/models/orders.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Orders>(
      builder: (context, orders, child) {
        final userOrders = orders.orderItems;

        return Scaffold(
          appBar: AppBar(
            title: const Text("คำสั่งซื้อของฉัน"),
            backgroundColor: Colors.grey.shade100,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          backgroundColor: Colors.grey.shade200,
          body: userOrders.isEmpty
              ? const Center(
                  child: Text(
                    "คุณยังไม่มีคำสั่งซื้อ",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: userOrders.length,
                  itemBuilder: (context, index) {
                    final orderItem = userOrders[index];
                    return MyCartTile(
                      cartItem: orderItem,
                      removeButtons: true, // ซ่อนปุ่มเพิ่ม/ลดและลบ
                    );
                  },
                ),
        );
      },
    );
  }
}
