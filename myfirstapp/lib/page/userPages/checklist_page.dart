import 'package:flutter/material.dart';
import 'package:myfirstapp/page/userPages/thank_you_page.dart';
import 'package:provider/provider.dart';
import 'package:myfirstapp/models/new_cart.dart';
import 'package:myfirstapp/components/userComponents/cart_tile.dart';
import 'package:myfirstapp/components/my_button.dart';
import 'package:myfirstapp/models/orders.dart';

class ChecklistPage extends StatelessWidget {


  const ChecklistPage({super.key, }); // กำหนด required

  @override
  Widget build(BuildContext context) {
    return Consumer<NewCart>(
      builder: (context, cart, child) {
        final userCart = cart.items;
        const double shippingFee = 100.0;

        return Scaffold(
          appBar: AppBar(
            title: const Text("รายการสินค้าที่สั่งซื้อ"),
            backgroundColor: Colors.grey.shade100,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          backgroundColor: Colors.grey.shade200,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: ListView.builder(
                  itemCount: userCart.length,
                  itemBuilder: (context, index) {
                    final cartItem = userCart[index];
                    return MyCartTile(
                      cartItem: cartItem,
                      removeButtons: true,
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade400, width: 1),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ราคาสินค้ารวม
                      Text(
                        "ราคาสินค้ารวม: \$${cart.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),

                      // ค่าขนส่ง
                      Text(
                        "ค่าขนส่ง: \$${shippingFee.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),

                      // ราคารวมทั้งหมด
                      Text(
                        "ราคารวมทั้งหมด: \$${(cart.totalPrice + shippingFee).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),

                      ElevatedButton(
                        onPressed: () {
                          // เพิ่มรายการใน Orders
                          final ordersProvider =
                              Provider.of<Orders>(context, listen: false);
                          ordersProvider.addOrder(List.from(cart.items));

                          // เคลียร์ตะกร้า
                          cart.clearCart();

                          // นำทางไปยัง ThankYouPage พร้อมส่ง userName
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ThankYouPage(userName: "userName"), // ส่ง userName
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Center(
                          child: Text(
                            "ชำระเงิน",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
