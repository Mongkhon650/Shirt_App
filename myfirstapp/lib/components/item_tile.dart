import 'package:flutter/material.dart';
import '../models/item.dart';
import 'package:myfirstapp/models/stock.dart';

class ItemTile extends StatelessWidget {
  final Shirt shirt;

  const ItemTile({super.key, required this.shirt});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5), // ปรับระยะห่างระหว่างแต่ละ Container
      height: 250, // ปรับความสูงของ Container ให้เหมาะสม
      width: 140, // ปรับความกว้างของ Container ให้เหมาะสมกับรูปภาพ
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              shirt.imagePath[0], // เข้าถึงภาพแรกจาก List<String>
              fit: BoxFit.cover,
              width: 140,
              height: 180, // ปรับความสูงของรูปภาพให้เหมาะสมกับ Container
            ),
          ),
          
          const SizedBox(height: 8),

          // Display discounted price if promotion exists, otherwise original price only
          if (shirt.promotion != null) ...[
            Row(
              children: [
                Text(
                  "\$${calculateDiscountedPrice(shirt.price, shirt.promotion!).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "\$${shirt.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ] else ...[
            // If no promotion, show the original price in standard font
            Text(
              "\$${shirt.price.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],

          // Shirt name
          Text(
            shirt.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
