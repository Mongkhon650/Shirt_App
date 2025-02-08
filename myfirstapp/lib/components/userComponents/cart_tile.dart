import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfirstapp/models/new_cart.dart';

class MyCartTile extends StatelessWidget {
  final CartItem cartItem;
  final bool removeButtons;

  const MyCartTile({super.key, required this.cartItem, this.removeButtons = true});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewCart>(
      builder: (context, cart, child) => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black, width: 1),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          cartItem.image,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                              style: TextStyle(color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                      if (!removeButtons) //ซ่อนปุ่มเพิ่ม-ลดถ้า removeButtons เป็น true
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (cartItem.quantity > 1) {
                                    cart.updateItemQuantity(cartItem.cartItemId, cartItem.quantity - 1);
                                  }
                                },
                              ),
                              Text('${cartItem.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  cart.updateItemQuantity(cartItem.cartItemId, cartItem.quantity + 1);
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!removeButtons)
            Positioned(
              top: 16,
              right: 28,
              child: GestureDetector(
                onTap: () {
                  cart.removeItem(cartItem.cartItemId);
                },
                child: Icon(Icons.close, color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}
