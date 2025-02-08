import 'package:flutter/material.dart';
import 'new_cart.dart';

class Orders with ChangeNotifier {
  final List<CartItem> _orderItems = [];

  List<CartItem> get orderItems => List.unmodifiable(_orderItems);

  void addOrder(List<CartItem> items) {
    _orderItems.addAll(items);
    notifyListeners();
  }

  void clearOrders() {
    _orderItems.clear();
    notifyListeners();
  }
}
