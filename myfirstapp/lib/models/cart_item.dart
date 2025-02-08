
import 'item.dart';

class CartItem {
  final Shirt shirt;
  final ShirtSize selectedSize;
  final ShirtColor selectedColor;
  final int quantity;

  CartItem({
    required this.shirt,
    required this.selectedSize,
    required this.selectedColor,
    this.quantity = 1,
  });

  // คำนวณราคาโดยคูณกับจำนวนสินค้า
  double get totalPrice => shirt.getDiscountedPrice() * quantity;
}
