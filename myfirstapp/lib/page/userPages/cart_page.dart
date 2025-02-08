import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfirstapp/models/new_cart.dart';
import 'package:myfirstapp/components/userComponents/cart_tile.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'select_address.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<void> _fetchCartFuture;

  @override
  void initState() {
    super.initState();
    _fetchCartFuture = Provider.of<NewCart>(context, listen: false).fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.grey.shade100,
        foregroundColor: Colors.black,
        actions: [
          Consumer<NewCart>(
            builder: (context, cart, child) {
              bool hasItems = cart.items.isNotEmpty;
              return hasItems
                  ? IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("ลบสินค้าทั้งหมด?"),
                      content: const Text("คุณแน่ใจหรือไม่ว่าต้องการลบสินค้าทั้งหมดออกจากตะกร้า?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("ยกเลิก"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // ปิด Dialog
                            cart.clearCart(); // ล้างตะกร้า
                          },
                          child: const Text("ลบ"),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete, color: Colors.black),
              )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      body: FutureBuilder<void>(
        future: _fetchCartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // กำลังโหลด
          } else if (snapshot.hasError) {
            return Center(child: Text("เกิดข้อผิดพลาด: ${snapshot.error}"));
          }

          return Consumer<NewCart>(
            builder: (context, cart, child) {
              final userCart = cart.items;
              print("🔹 Cart in UI: ${userCart.length} items");

              return Column(
                children: [
                  Expanded(
                    child: userCart.isNotEmpty
                        ? ListView.builder(
                      itemCount: userCart.length,
                      itemBuilder: (context, index) {
                        final cartItem = userCart[index];
                        print("📦 Rendering item: ${cartItem.name}");
                        return MyCartTile(
                          cartItem: cartItem,
                          removeButtons: false,
                        );
                      },
                    )
                        : const Center(
                      child: Text("ไม่มีสินค้าอยู่ในตะกร้าของคุณ"),
                    ),
                  ),
                  if (userCart.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: MyButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SelectAddress(),
                            ),
                          );
                        },
                        text: "เลือกสถานที่ส่ง",
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
