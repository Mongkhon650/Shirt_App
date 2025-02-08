import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myfirstapp/utils/config.dart';

class CartItem {
  final int cartItemId;
  final int productId;
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

class NewCart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice => _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity)); // ✅ เพิ่ม getter นี้

  Future<void> fetchCart() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;
    if (userId == 0) return;

    final url = Uri.parse("${AppConfig.baseUrl}/api/get-cart/$userId");
    print("🔹 Fetching cart from: $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      _items = data.map((item) => CartItem(
        cartItemId: item['cart_item_id'],
        productId: item['product_id'],
        name: item['name'],
        price: double.parse(item['price'].toString()),
        image: item['image'] ?? "https://via.placeholder.com/150",
        quantity: item['quantity'],
      )).toList();

      notifyListeners();
    } else {
      print("Failed to fetch cart: ${response.body}");
    }
  }



  Future<void> addToCart(CartItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;
    if (userId == 0) return;

    final url = Uri.parse("${AppConfig.baseUrl}/api/add-to-cart");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "user_id": userId,
      "product_id": item.productId,
      "quantity": item.quantity,
    });

    print("🔹 Sending request to: $url");
    print("🔹 Headers: $headers");
    print("🔹 Body: $body");

    final response = await http.post(url, headers: headers, body: body);

    print("🔹 Response status: ${response.statusCode}");
    print("🔹 Response body: ${response.body}");

    if (response.statusCode == 200) {
      fetchCart();
    } else {
      print("Failed to add to cart: ${response.body}");
    }
  }


  Future<void> updateItemQuantity(int cartItemId, int newQuantity) async {
    if (newQuantity < 1) return; // ห้ามลดจนเหลือ 0

    final url = Uri.parse("${AppConfig.baseUrl}/api/update-cart-item/$cartItemId");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({"quantity": newQuantity});

    print("🔹 Updating cart item: $cartItemId to quantity: $newQuantity");

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print("✅ Cart item updated successfully!");
      await fetchCart(); // อัปเดตตะกร้าหลังจากเปลี่ยนจำนวนสินค้า
    } else {
      print("❌ Failed to update cart item: ${response.body}");
    }
  }


  Future<void> removeItem(int cartItemId) async {
    final url = Uri.parse("${AppConfig.baseUrl}/api/remove-from-cart/$cartItemId");

    print("🔹 Sending DELETE request to: $url");

    final response = await http.delete(url);

    print("🔹 Response status: ${response.statusCode}");
    print("🔹 Response body: ${response.body}");

    if (response.statusCode == 200) {
      fetchCart();  // โหลดตะกร้าใหม่หลังจากลบ
    } else {
      print("Failed to remove item: ${response.body}");
    }
  }


  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;
    if (userId == 0) return;

    final url = Uri.parse("${AppConfig.baseUrl}/api/clear-cart/$userId");

    print("🔹 Sending DELETE request to: $url");

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print("Cart cleared successfully!");
      _items.clear();  // ล้างรายการสินค้าในตะกร้า
      notifyListeners();
    } else {
      print("Failed to clear cart: ${response.body}");
    }
  }

}
