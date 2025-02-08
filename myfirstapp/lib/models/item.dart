import 'dart:ffi';


// items
class Shirt {
  final String name;
  final String description;
  final List<String> imagePath; // เปลี่ยนจาก String เป็น List<String> เพื่อเก็บหลายรูป
  final double price;
  final ShirtCategory category;
  final List<ShirtSize> availableSize;
  final List<ShirtColor> availableColor;
  final ShirtType type;
  final int stock;
  final double? promotion;

  Shirt({
    required this.name,
    required this.description,
    required this.imagePath, // ปรับให้รองรับหลายรูป
    required this.price,
    required this.category,
    required this.availableSize,
    required this.availableColor,
    required this.type,
    required this.stock,
    this.promotion,
  });

  double getDiscountedPrice() {
    if (promotion != null) {
      return price * (1 - promotion! / 100);
    }
    return price;
  }
}
// ShirtType
enum ShirtType {
  featured,
  bestSell,
  promotion,
}

// ShirtCategory
enum ShirtCategory {
  man,
  woman,
  kid,
}

// ShirtSize
class ShirtSize {
  final String name;

  ShirtSize({
    required this.name,
  });
}

// ShirtColor
class ShirtColor {
  final String name;

  ShirtColor({
    required this.name,
  });
}

